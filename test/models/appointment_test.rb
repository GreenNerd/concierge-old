require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @business_category = FactoryGirl.create :business_category
    @appointment = FactoryGirl.create :appointment, business_category: @business_category
  end

  test 'should create appointment' do
    assert @appointment.persisted?
  end

  test 'should save appointment without business_category' do
    @appointment.business_category = nil
    assert_not @appointment.valid?
  end

  test 'should save appointment without id_number' do
    @appointment.id_number = nil
    assert_not @appointment.valid?
  end

  test 'should save appointment without wrong formatted id_number' do
    @appointment.id_number = '12345678901234567Y'
    assert_not @appointment.valid?

    @appointment.id_number = '12345678901234567'
    assert_not @appointment.valid?

    @appointment.id_number = '1234567890123456789'
    assert_not @appointment.valid?

    @appointment.id_number = '01234567890123456789'
    assert_not @appointment.valid?
  end

  test 'should save with low or upper letter on id_number' do
    new_id_number = '12345678901234567x'
    @appointment.id_number = new_id_number

    assert @appointment.valid?
    assert new_id_number.upcase, @appointment.id_number
  end
end
