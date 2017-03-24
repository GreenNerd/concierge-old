require 'test_helper'

class Admin::AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_availabilities_url
    assert_response :success
  end
end
