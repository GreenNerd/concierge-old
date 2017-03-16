class AddAdvanceReservationDaysToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :advance_reservation_days, :integer, default: 5
  end
end
