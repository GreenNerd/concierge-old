class BusinessCategory < ApplicationRecord
  validates :prefix, presence: true
  validates :number, presence: true
  validates :name, presence: true

  has_many :business_counters, dependent: :delete_all
  has_many :appointments, dependent: :delete_all

  def update_counters(numbers)
    # remove
    business_counters.where.not(number: numbers).delete_all

    # add
    numbers.each do |num|
      business_counters.where(number: num).first_or_create
    end
  end
end
