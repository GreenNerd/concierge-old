class AppointmentResetHandler
  def call(job, time)
    Rails.logger.info "Scheduler: * #{time} - Handler AppointmentResetHandler called for #{job.id}"

    Appointment.where(expired: false)
               .where('appoint_at < ?', Date.today)
               .update_all(expired: true)

    return unless Availability.available_at?(Date.today)

    Appointment.where(expired: false)
               .where(appoint_at: Date.today)
               .find_each(&:reserve!)
  end
end
