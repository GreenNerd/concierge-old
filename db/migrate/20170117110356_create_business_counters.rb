class CreateBusinessCounters < ActiveRecord::Migration[5.0]
  def change
    create_table :business_counters do |t|
      t.belongs_to :business_category, foreign_key: true
      t.integer :number
    end
  end
end
