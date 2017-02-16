class AddBTextAndATextAndAAppointmentsCountToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :b_text, :string
    add_column :settings, :a_text, :string
    add_column :settings, :a_appointments_count, :integer
  end
end
