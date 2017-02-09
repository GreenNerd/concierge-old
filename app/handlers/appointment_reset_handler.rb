class AppointmentResetHandler
  def call(job, time)
    Rails.logger.info "Scheduler: * #{time} - Handler AppointmentResetHandler called for #{job.id}"

    Appointment.where("appoint_at >= '#{Date.today}'")
               .where("appoint_at < '#{Date.tomorrow}'")
               .find_each do |appointment|
                res = appointment.create_number

                if res
                  appointment.update_columns queue_number: res[:queue_number]
                else
                  Rails.logger.warn "Failed to create number for Appointment ##{appointment.id}"
                end
               end
  end
end
