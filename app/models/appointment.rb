class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9][0-9]{16}[0-9X]\Z/ }

  validates :phone_number, presence: true, format: { with: /\A[0-9]{11}\Z/ }

  belongs_to :business_category

  before_validation :upcase_id_number

  validate :has_unexpired_appointment
  validate :in_today
  validate :in_limitation

  private

  def has_unexpired_appointment
    if Appointment.where("id_number = ? and expired = ?", id_number, false).count > 0
      errors.add(:id_number, "you have unexpired appointment")
    end
  end

  def in_today
    if appoint_at < Date.today || appoint_at > 5.days.from_now
      errors.add(:appoint_at, "your appoint is not in today")
    end
  end

  def in_limitation
    limitation = Setting.first&.limitation
    finished = Appointment.where("appoint_at = ?", Date.today).count
    if limitation - finished < 0
      errors.add(:id_number, "the people number is reaching limitation")
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end
end
