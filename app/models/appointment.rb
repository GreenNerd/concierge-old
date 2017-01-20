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
    if Appointment.where(appoint_at: Date.today).count >= Setting.instance.limitation
      errors.add(:id_number, :reached_limitation)
    end
  end

  def reserve
    res = MachineService.new({
      trans_code: Setting.instance.trans_code,
      inst_no: Setting.instance.inst_no,
      biz_type: self.business_category.number,
      term_no: Setting.instance.term_no
    }).appoint
    if !res
      errors.add(:base, :reservation_failed)
      throw :abort
    else
      self.business_category.queue_number = res[:QueueNumber]
      self.queue_number = res[:QueueNumber]
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end
end
