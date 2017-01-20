class AddLimitationToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :limitation, :integer
  end
end
