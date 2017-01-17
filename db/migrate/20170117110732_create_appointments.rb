class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.date :appoint_at, index: true
      t.belongs_to :business_category, foreign_key: true
      t.string :id_number, index: true
      t.string :phone_number
      t.string :queue_number
      t.boolean :expired, default: false

      t.timestamps
    end
  end
end
