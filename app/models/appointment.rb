class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9][0-9]{16}[0-9X]\Z/ }

  belongs_to :business_category

  before_validation :upcase_id_number

  def to_param
    id_number
  end

  private

  def upcase_id_number
    self.id_number = id_number&.upcase
  end
end
