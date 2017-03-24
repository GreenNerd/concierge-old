class AddSyncJobIdAndAppointmentResetJobIdAndTotalNumberCountAndPassNumberCountToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :sync_job_id, :string
    add_column :settings, :appointment_reset_job_id, :string
    add_column :settings, :total_number_count, :integer
    add_column :settings, :pass_number_count, :integer
  end
end
