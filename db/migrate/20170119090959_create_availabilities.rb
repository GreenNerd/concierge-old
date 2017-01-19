class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.boolean :available, index: true
      t.string :effective_date, index: true
    end
  end
end
