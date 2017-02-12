require 'test_helper'

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
    @availability = FactoryGirl.create(:availability)
  end

  test 'should get index' do
    get admin_availabilities_url, headers: @admin_headers
    assert_response :success
  end

  test 'should show create avaliability' do
    get admin_availabilities_url, headers: @admin_headers
    assert_select 'div', '新增放假调休'
  end

  test 'create availability' do
    new_available = false
    new_effective_date = '02-15'

    assert_difference('Availability.count') do
      post admin_availabilities_url,
        params: { availability: { available: new_available, effective_date: new_effective_date } },
        headers: @admin_headers,
        xhr: true
    end
  end

  test "should success delete" do
    availability = FactoryGirl.create :availability, available: false, effective_date: "02-16"
    assert_difference('Availability.count', -1) do
      delete admin_availability_url(availability),
        headers: @admin_headers,
        xhr: true
    end
  end
end
