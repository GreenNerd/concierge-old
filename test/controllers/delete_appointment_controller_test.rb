require 'test_helper'

class DeleteAppointmentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get delete_appointment_index_url
    assert_response :success
  end

end
