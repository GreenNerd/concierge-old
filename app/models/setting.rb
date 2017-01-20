class Setting < ApplicationRecord
  def self.instance
    first || create
  end
end
