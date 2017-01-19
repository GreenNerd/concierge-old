require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  setup do
    @availability = FactoryGirl.build :availability
  end

  test 'should be valid' do
    assert @availability.valid?
  end

  test 'should be invalid with blank effective_date' do
    @availability.effective_date = nil
    assert_not @availability.valid?

    @availability.effective_date = '   '
    assert_not @availability.valid?
  end

  test 'should be invalid with wrong formatted effective_date' do
    @availability.effective_date = '1'
    assert_not @availability.valid?
  end
end
