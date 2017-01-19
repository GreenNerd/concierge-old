class Availability < ApplicationRecord
  validates_inclusion_of :available, in: [true, false]
  validates :effective_date, presence: true

  before_validation :format_effective_date

  private

  def format_effective_date
    return unless effective_date.present?

    if effective_date.to_s =~ /-/
      month, day = effective_date.split(/-/).map(&:to_i)
      self.effective_date = begin
                              Date.new(1, month, day)
                                  .strftime('%m-%d'.freeze)
                            rescue
                              nil
                            end
    else
      errors.add(:effective_date, :invalid)
    end
  end
end
