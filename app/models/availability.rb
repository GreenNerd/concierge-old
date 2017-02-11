class Availability < ApplicationRecord
  validates_inclusion_of :available, in: [true, false]
  validates :effective_date, presence: true, uniqueness: true

  before_validation :format_effective_date

  def human_available
    available? ? '班'.freeze : '休'.freeze
  end

  def self.next_available_dates(days: 5)
    dates = []
    date = Date.today

    until dates.length >= days
      dates.push date if available_at?(date)
      date = date.next_day
    end

    dates
  end

  def self.available_at?(date)
    return false unless date.acts_like?(:date) || date.acts_like?(:time)

    availability = find_by(effective_date: date.to_s(:month_and_day))

    if availability
      availability.available?
    else
      date.on_weekday?
    end
  end

  private

  def format_effective_date
    return unless effective_date.present?

    if effective_date.to_s =~ /-/
      month, day = effective_date.split(/-/).map(&:to_i)
      self.effective_date = begin
                              Date.new(1, month, day).to_s(:month_and_day)
                            rescue
                              nil
                            end
    else
      errors.add(:effective_date, :invalid)
    end
  end
end
