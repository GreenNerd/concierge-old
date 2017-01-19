class Availability < ApplicationRecord
  DATE_FORMAT = '%m-%d'.freeze

  validates_inclusion_of :available, in: [true, false]
  validates :effective_date, presence: true, uniqueness: true

  before_validation :format_effective_date

  def human_available
    available? ? '班'.freeze : '休'.freeze
  end

  def self.available_at?(date)
    return false unless date.respond_to?(:strftime)

    availability = find_by(effective_date: date.strftime(DATE_FORMAT))

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
                              Date.new(1, month, day)
                                  .strftime(DATE_FORMAT)
                            rescue
                              nil
                            end
    else
      errors.add(:effective_date, :invalid)
    end
  end
end
