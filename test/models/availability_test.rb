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

  test 'should be invalid with repeated effective_date' do
    @availability.save
    another_availability = FactoryGirl.build :availability, effective_date: @availability.effective_date
    assert_not another_availability.valid?
  end

  test '#available_at?' do
    format_date = lambda do |date|
      date.strftime(Availability::DATE_FORMAT)
    end

    day_off_date = Date.today.last_weekday
    day_duty_date = Date.today.sunday

    FactoryGirl.create :availability, available: false, effective_date: format_date.call(day_off_date)
    FactoryGirl.create :availability, available: true, effective_date: format_date.call(day_duty_date)

    assert_not Availability.available_at?(day_off_date)
    assert Availability.available_at?(day_duty_date)

    # Weekend
    assert_not Availability.available_at?(Date.today.next_year.sunday)

    # Weekday
    assert Availability.available_at?(Date.today.next_year.next_weekday)

    # Blank
    assert_not Availability.available_at?(nil)
  end
end
