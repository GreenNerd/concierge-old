require 'test_helper'

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  test 'check enable before queue' do
    Setting.instance.update enable: false

    get new_appointment_url, params: { openid: '123' }
    assert_redirected_to closed_appointments_url
  end

  test 'should get new successfully' do
    Setting.instance.update enable: true

    get new_appointment_url, params: { openid: '123' }
    assert_response :success
  end
end
