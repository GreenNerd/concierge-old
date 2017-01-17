class BusinessCategory < ApplicationRecord
  validates :prefix, presence: true
  validates :number, presence: true
  validates :name, presence: true

  has_many :business_counters, dependent: :delete_all
  has_many :appointments, dependent: :delete_all
end
