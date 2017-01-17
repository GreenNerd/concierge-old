class BusinessCategory < ApplicationRecord
  validates :prefix, presence: true
  validates :number, presence: true
  validates :name, presence: true
end
