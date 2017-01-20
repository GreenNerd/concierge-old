class Setting < ApplicationRecord
  cattr_accessor :sync_job
  cattr_accessor :appointment_reset_job

  after_update_commit :set_or_update_sync_job, if: :sync_interval_changed?
  after_update_commit :set_or_update_appointment_reset_job, if: :appoint_begin_at_changed?

  def self.instance
    first || create
  end

  def set_or_update_sync_job
    return unless avoid_scheduler?

    sync_job&.unschedule

    if sync_interval.present?
      self.sync_job = Rufus::Scheduler.singleton.every "#{sync_interval.to_i}m", SyncHandler.new, job: true
    elsif sync_job
      self.sync_job = nil
    end
  end

  def set_or_update_appoint_job
    return unless avoid_scheduler?

    appointment_reset_job&.unschedule

    if appoint_begin_at.present?
      first_at = Time.zone.parse(appoint_begin_at)
      first_at = first_at.tomorrow if first_at.past?

      self.appointment_reset_job = Rufus::Scheduler.singleton.every '1d'.freeze, AppointmentResetHandler.new, first_at: first_at, job: true
    elsif sync_job
      self.appointment_reset_job = nil
    end
  end

  def avoid_scheduler?
    Rails.env.test? || defined?(Rails::Console)
  end
end
