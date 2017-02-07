require 'test_helper'

class BusinessCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
  end

  test 'should get index' do
    get business_categories_url, headers: @admin_headers
    assert_response :success
  end

end
