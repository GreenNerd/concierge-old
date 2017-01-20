class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9]\d{16}[0-9X]\Z/ }
  validates :phone_number, presence: true, format: { with: /\A1\d{10}\Z/ }
  validates :appoint_at, presence: true
  validates :business_category, presence: true
  validate :ensure_clear_appointment
  validate :ensure_appoint_at_within_range
  validate :ensure_available

  belongs_to :business_category

  before_validation :upcase_id_number
  before_create :reserve
  after_create_commit :update_queue_number_of_business_category

  def to_param
    id_number
  end

  private

  def ensure_clear_appointment
    return unless id_number.present?

    if Appointment.where(id_number: id_number, expired: false).exists?
      errors.add(:base, :unclear_appointment)
    end
  end

  def ensure_appoint_at_within_range
    return unless appoint_at.present?

    unless appoint_at.in?(Availability.next_available_dates)
      errors.add(:appoint_at, :invalid)
    end
  end

  def ensure_available
    if Appointment.where(appoint_at: Date.today).count >= Setting.instance.limitation.to_i
      errors.add(:base, :reached_limitation)
    end
  end

  def reserve
    res = MachineService.new.create_number(business_category.number)

    if res
      self.queue_number = res[:queue_number]
    else
      errors.add(:base, :reservation_failed)
      throw :abort
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end

  def update_queue_number_of_business_category
    business_category.update queue_number: queue_number
  end
end
