class AddOpenidToAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :openid, :string
  end
end
