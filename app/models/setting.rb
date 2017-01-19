class Setting < ApplicationRecord
  @@instance = Setting.first if Setting.all.exists?

  def self.instance
    return @@instance
  end
end
