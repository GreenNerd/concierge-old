require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @business_category = FactoryGirl.create :business_category
    @setting = FactoryGirl.create :setting, limitation: 1000
    @appointment = FactoryGirl.build :appointment, business_category: @business_category

    xml_str = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <Package>
        <TranCode>#{Setting.first.trans_code}</TranCode>
        <InstNo>#{Setting.first.inst_no}</InstNo>
        <BizType>#{@business_category.number}</BizType>
        <TermNo>#{Setting.first.term_no}</TermNo>
      </Package>
    EOF
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

    WebMock.stub_request(:post, "http://192.168.18.88:8080/QueueServer/1.0/Services/createNumber").
      with(body: xml_str, headers: {"Content-Type" => 'application/xml'}).
      to_return(body: xml_res)

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
    @appointment.appoint_at = 6.days.from_now
    assert_not @appointment.valid?
  end

  test "should fail for appointment count is reaching limitation" do
    @setting.update(limitation: 1)
    FactoryGirl.create :appointment, business_category: @business_category
    assert_not @appointment.valid?
  end

  test 'should be valid when not reached limitation' do
    @setting.update(limitation: 100)
    assert @appointment.valid?
  end

  test 'should failed for post request is unreachable' do
    @setting.update(mip: '192.168.11.11')
    assert_not @appointment.valid?
  end

  test 'should succes for default post' do
    assert @appointment.valid?
  end
end
