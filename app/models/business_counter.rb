class BusinessCounter < ApplicationRecord
  validate :check_serving_number

  after_update_commit :pass_appointments

  belongs_to :business_category

  private

  def pass_appointments
    return if serving_number == '0000'.freeze
    business_category.appointments.where('queue_number < ?', serving_number).update_all expired: true
  end

  def check_serving_number
    errors.add(:base, :invalid) if serving_number == '0000'.freeze
  end
end
