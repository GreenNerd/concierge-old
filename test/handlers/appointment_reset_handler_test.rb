require 'test_helper'

class AppointmentResetHandlerTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create :setting

    xml_res = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <Package>
        <InstNo>10101</InstNo>
        <QueueNumber>A003</QueueNumber>
        <SerialName>综合业务</SerialName>
        <ServCounter>1,2</ServCounter>
        <QueueNum>6</QueueNum>
        <RspCode>0</RspCode>
        <RspMsg>取号成功</RspMsg>
      </Package>
    EOF

    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber")
      .to_return(body: xml_res)

    @business_category = FactoryGirl.create :business_category

    Timecop.freeze('2017-2-8')
    @appointment_1 = FactoryGirl.create :appointment, business_category: @business_category, appoint_at: '2017-2-9'
    @appointment_2 = FactoryGirl.create :appointment, business_category: @business_category, appoint_at: '2017-2-10', id_number: '510111111111131231'
    Timecop.freeze('2017-2-9')
  end

  teardown do
    Timecop.return
  end

  test 'should update appointment_1 queue_number' do
    run_job AppointmentResetHandler
    assert_equal @appointment_1.reload.queue_number, 'A003'
  end

  test 'should not update appointment_2 queue_number' do
    run_job AppointmentResetHandler
    assert_not_equal @appointment_2.reload.queue_number, 'A003'
  end
end
