class BusinessCategory < ApplicationRecord
  validates :prefix, presence: true
  validates :number, presence: true
  validates :name, presence: true

  has_many :business_counters, dependent: :delete_all
  has_many :appointments, dependent: :delete_all

  def build_counters numbers
    return if numbers.blank?

    BusinessCounter.where.not("number = ANY(ARRAY#{numbers})").destroy_all
    not_exists = numbers - BusinessCounter.where("number = ANY(ARRAY#{numbers})").pluck(:number)
    not_exists.each do |number|
      business_counters.create number: number
    end
  end
end
