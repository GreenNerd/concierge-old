class AddAppointEndAtToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :appoint_end_at, :string
  end
end
