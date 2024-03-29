class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9]\d{16}[0-9X]\Z/ }
  validates :phone_number, presence: true, format: { with: /\A1\d{10}\Z/ }
  validates :appoint_at, presence: true
  validates :openid, presence: true
  validates :business_category, presence: true
  validate :ensure_clear_appointment, on: :create
  validate :ensure_appoint_at_within_range
  validate :ensure_available
  validate :check_window_time, on: :create
  validate :check_id_number

  belongs_to :business_category

  scope :unreserved, -> { where(queue_number: nil) }
  scope :past, -> { where('appoint_at < ?', Date.today) }
  scope :unexpired, -> { where(expired: false) }
  scope :today, -> { on(Date.today) }
  scope :on, -> (day) { where(appoint_at: day) }

  before_validation :upcase_id_number
  before_create :reserve, if: proc { |appointment| appointment.appoint_at.today? }
  after_create_commit :update_queue_number_of_business_category

  def reserve
    reserve_from_machine

    unless queue_number?
      errors.add(:base, :reservation_failed)
      throw :abort
    end
  end

  def reserve!
    reserve_from_machine

    save(validate: false) if queue_number?
  end

  def wait_number
    return unless appoint_at&.today?
    return unless queue_number

    _queue_number = queue_number.match(/\d+/)[0].to_i
    max_serving_number = business_category.business_counters.maximum(:serving_number)
    max_serving_number = max_serving_number.to_s[/\d+/]
    return unless max_serving_number
    _queue_number - max_serving_number.to_i
  end

  private

  def ensure_clear_appointment
    return unless openid.present?

    if Appointment.where(openid: openid, expired: false).exists?
      errors.add(:base, :unclear_appointment)
    end
  end

  def ensure_appoint_at_within_range
    return unless appoint_at.present?

    unless appoint_at.in?(Availability.next_available_dates(days: Setting.instance.advance_reservation_days))
      errors.add(:appoint_at, :invalid)
    end
  end

  def ensure_available
    return unless appoint_at.present?

    if Appointment.where(appoint_at: appoint_at).count >= Setting.instance.limitation.to_i
      errors.add(:base, :reached_limitation)
    end
  end

  def reserve_from_machine
    return if queue_number?

    machine_service = ::MachineService.new

    rsp = machine_service.create_number(business_category.number)
    if rsp
      business_category.update_counters rsp.dig(:package, :serv_counter).to_s.scan(/\d+/).map(&:to_i)
      self.queue_number = rsp.dig(:package, :queue_number)
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end

  def update_queue_number_of_business_category
    business_category.update queue_number: queue_number
  end

  def check_window_time
    unless Setting.instance.in_window_time?
      errors.add(:base, :out_of_window_time)
    end
  end

  def check_id_number
    return unless (/\A[1-9]\d{16}[0-9X]\Z/).match(id_number.to_s)

    numbers = id_number.split('')
    last = numbers.pop
    numbers.map!(&:to_i)
    multiply_array = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]

    sum = numbers.map.with_index do |number, n|
               number * multiply_array[n]
             end.sum
    remainder = sum % 11

    remainder_map = {
      0 => '1', 1 => '0', 2 => 'X', 3 => '9', 4 => '8', 5 => '7',
      6 => '6', 7 => '5', 8 => '4', 9 => '3', 10 => '2'
    }

    if remainder_map[remainder] != last
      errors.add(:base, :invalid_id_number)
    end
  end
end
