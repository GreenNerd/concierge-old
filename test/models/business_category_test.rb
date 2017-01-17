require 'test_helper'

class BusinessCategoryTest < ActiveSupport::TestCase
  setup do
    @business_category = FactoryGirl.create :business_category
  end

  test 'should save category' do
    assert @business_category.save
  end

  test 'should not save category without prefix' do
    @business_category.prefix = ''
    assert_not @business_category.save
  end

  test 'should not save category without number' do
    @business_category.number = ''
    assert_not @business_category.save
  end

  test 'should not save category without name' do
    @business_category.name = ''
    assert_not @business_category.save
  end
end
