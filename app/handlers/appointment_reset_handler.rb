class AppointmentResetHandler
  def call(job, time)
    Rails.logger.info "Scheduler: * #{time} - Handler AppointmentResetHandler called for #{job.id}"

    return if Availability.available_at?(Date.today)
    Appointment.where(appoint_at: Date.today).find_each { |appointment| create_number(appointment) }
  end

  def create_number appointment
    3.times do |n|
      res = appointment.create_number

      if res
        appointment.update_columns queue_number: res.dig(:package, :queue_number)
        break
      else
        Rails.logger.warn "Failed to create number for Appointment ##{appointment.id} and retry #{n}"
      end
    end
  end
end
