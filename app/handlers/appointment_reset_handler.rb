class AppointmentResetHandler
  def call(job, time)
    Rails.logger.info "Scheduler: * #{time} - Handler AppointmentResetHandler called for #{job.id}"

    BusinessCounter.update_all serving_number: nil

    Appointment.unexpired.past.update_all(expired: true)

    return unless Availability.available_at?(Date.today)

    Appointment.unexpired.today.unreserved.find_each(&:reserve!)
  end
end
