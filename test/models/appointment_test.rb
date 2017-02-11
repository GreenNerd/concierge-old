require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create :setting

    @avaiable_appoint_at = Availability.next_available_dates(days: 1).first

    @business_category = FactoryGirl.create :business_category

    @appointment = FactoryGirl.build :appointment, business_category: @business_category, appoint_at: @avaiable_appoint_at

    xml_res = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <Package>
        <InstNo>10101</InstNo>
        <QueueNumber>A001</QueueNumber>
        <SerialName>综合业务</SerialName>
        <ServCounter>1,2</ServCounter>
        <QueueNum>6</QueueNum>
        <RspCode>0</RspCode>
        <RspMsg>取号成功</RspMsg>
      </Package>
    EOF

    WebMock
      .stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber")
      .to_return(body: xml_res)
  end

  test 'should create appointment' do
    assert @appointment.valid?
  end

  test 'should save appointment without business_category' do
    @appointment.business_category = nil
    assert_not @appointment.valid?
  end

  test 'should save appointment without id_number' do
    @appointment.id_number = nil
    assert_not @appointment.valid?
  end

  test 'should save appointment without wrong formatted id_number' do
    @appointment.id_number = '12345678901234567Y'
    assert_not @appointment.valid?

    @appointment.id_number = '12345678901234567'
    assert_not @appointment.valid?

    @appointment.id_number = '1234567890123456789'
    assert_not @appointment.valid?

    @appointment.id_number = '01234567890123456789'
    assert_not @appointment.valid?
  end

  test 'should save with low or upper letter on id_number' do
    new_id_number = '12345678901234567x'
    @appointment.id_number = new_id_number

    assert @appointment.valid?
    assert new_id_number.upcase, @appointment.id_number
  end

  test 'should save appointment with phone number' do
    @appointment.phone_number = nil
    assert_not @appointment.valid?
  end

  test 'should save appointment with wrong phone number' do
    @appointment.phone_number = '1310000111122'
    assert_not @appointment.valid?

    @appointment.phone_number = '131000011'
    assert_not @appointment.valid?
  end

  test 'should fail for already has a appointment' do
    apo = FactoryGirl.create :appointment, business_category: @business_category
    @appointment.id_number = apo.id_number
    assert_not @appointment.valid?
  end

  test 'should fail for date is not in servie' do
    @appointment.appoint_at = 1.day.ago
    assert_not @appointment.valid?
  end

  test 'should fail for reached limitation' do
    Setting.instance.update(limitation: 1)
    FactoryGirl.create :appointment, business_category: @business_category
    assert_not @appointment.valid?
  end

  test 'should be valid when not reached limitation' do
    Setting.instance.update(limitation: 100)
    assert @appointment.valid?
  end

  test 'should failed when reserve failed' do
    failed_xml = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <Package>
        <InstNo>10101</InstNo>
        <RspCode>100</RspCode>
        <RspMsg>取号失败</RspMsg>
      </Package>
    EOF

    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber")
      .to_return(body: failed_xml)

    Timecop.freeze(@avaiable_appoint_at) do
      assert_not @appointment.save
    end
  end

  test 'should succes for default post' do
    @business_category.update(number: 1)
    assert @appointment.valid?
  end

  test 'should reserve from machine' do
    @appointment.save
    assert_not @appointment.queue_number, 'A001'
  end

  test 'should reserve from machine if the appoint_at is available weekend' do
    appoint_at = Date.today.sunday

    Timecop.freeze appoint_at do
      @appointment.appoint_at = appoint_at

      assert_not @appointment.save

      FactoryGirl.create :availability, available: true, effective_date: appoint_at.to_s(:month_and_day)

      assert @appointment.save
    end
  end
end
