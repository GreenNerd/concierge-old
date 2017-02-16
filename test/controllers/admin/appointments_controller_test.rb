require 'test_helper'

class Admin::AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.instance.update FactoryGirl.attributes_for(:setting)
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

    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber")
      .to_return(body: xml_res)

    @business_category = FactoryGirl.create :business_category
    @appointment = FactoryGirl.create :appointment, business_category: @business_category
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
  end

  test 'should get index' do
    get admin_appointments_url, headers: @admin_headers
    assert_response :success
  end

  test 'should show admin_appointment' do
    get admin_appointment_url(@appointment), headers: @admin_headers
    assert_response :success
  end

  test 'should destroy admin_appointment' do
    assert_difference('Appointment.count', -1) do
      delete admin_appointment_url(@appointment), headers: @admin_headers
    end

    assert_redirected_to admin_appointments_url
  end
end
