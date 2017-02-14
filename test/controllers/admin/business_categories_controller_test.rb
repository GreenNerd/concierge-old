require 'test_helper'

class Admin::BusinessCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_category = FactoryGirl.create :business_category
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
  end

  test 'should get index' do
    get admin_business_categories_url, headers: @admin_headers
    assert_response :success
  end

  test 'should create business_category' do
    assert_difference('BusinessCategory.count') do
      post admin_business_categories_url,
        params: { business_category: FactoryGirl.attributes_for(:business_category) },
        headers: @admin_headers,
        xhr: true
    end
  end

  test 'should show business_category' do
    get admin_business_category_url(@business_category), headers: @admin_headers
    assert_response :success
  end

  test 'should update business_category' do
    new_name = 'test-name'
    patch admin_business_category_url(@business_category),
      params: { business_category: { name: new_name } },
      headers: @admin_headers,
      xhr: true

    assert_equal new_name, @business_category.reload.name
  end

  test 'should destroy business_category' do
    assert_difference('BusinessCategory.count', -1) do
      delete admin_business_category_url(@business_category), headers: @admin_headers, xhr: true
    end
  end
end
