class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9][0-9]{16}[0-9X]\Z/ }

  validates :phone_number, presence: true, format: { with: /\A1\d{10}\Z/ }

  belongs_to :business_category

  before_validation :upcase_id_number

  validate :has_unexpired_appointment,
           :in_today,
           :in_limitation,
           :get_appointment_from_machine

  private

  def has_unexpired_appointment
    if Appointment.where(id_number: id_number, expired: false).exists?
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
    finished = Appointment.where(appoint_at: Date.today).count
    if limitation - finished < 0
      errors.add(:id_number, "the people number is reaching limitation")
    end
  end

  def get_appointment_from_machine
    if self.business_category.present? && Setting.first.present?
      res = MachineService.new({
        trans_code: Setting.first.trans_code,
        inst_no: Setting.first.inst_no,
        biz_type: self.business_category.number,
        term_no: Setting.first.term_no
      }).appoint
      if !res
        errors.add(:id_number, "could not get data from appoint machine")
      else
        self.business_category.queue_number = res[:QueueNumber]
        self.queue_number = res[:QueueNumber]
      end
    else
      errors.add(:id_number, "could not get data from appoint machine")
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end
end
