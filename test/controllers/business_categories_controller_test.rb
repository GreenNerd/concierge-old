require 'test_helper'

class BusinessCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get business_categories_index_url
    assert_response :success
  end

  test "should get create" do
    get business_categories_create_url
    assert_response :success
  end

  test "should get show" do
    get business_categories_show_url
    assert_response :success
  end

  test "should get destroy" do
    get business_categories_destroy_url
    assert_response :success
  end

end
