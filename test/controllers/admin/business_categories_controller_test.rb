require 'test_helper'

class BusinessCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
    @business_category = FactoryGirl.create(:business_category)
  end

  test 'should get index successfully' do
    get admin_business_categories_url, headers: @admin_headers
    assert_response :success
  end

  test 'should show create business category' do
    get admin_business_categories_url, headers: @admin_headers
    assert_select 'div', '新增业务类型'
  end

  test 'create business category' do
    new_name = "撤销"
    new_number = 8
    new_prefix = 'H'

    assert_difference('BusinessCategory.count') do
      post admin_business_categories_url,
        params: { business_category: { name: new_name, number: new_number, prefix: new_prefix } },
        headers: @admin_headers,
        xhr: true
    end
  end

end
