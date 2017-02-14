class AddServNumberToBusinessCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :business_counters, :serving_number, :string
  end
end
