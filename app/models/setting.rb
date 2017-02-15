class Setting < ApplicationRecord
  cattr_accessor :setting

  cattr_accessor :sync_job
  cattr_accessor :appointment_reset_job
  cattr_accessor :total_number_count
  cattr_accessor :pass_number_count

  after_update_commit :set_or_update_sync_job, if: :sync_interval_changed?
  after_update_commit :set_or_update_appointment_reset_job, if: :appoint_begin_at_changed?

  after_commit :update_singleton

  def self.instance
    self.setting ||= first_or_create
  end

  def self.wait_number_count
    total_number_count.to_i - pass_number_count.to_i
  end

  def self.warmup
    instance.set_or_update_appoint_job
    instance.set_or_update_sync_job
  end

  def set_or_update_sync_job
    return unless avoid_scheduler?

    sync_job&.unschedule

    if sync_interval.present?
      self.sync_job = Rufus::Scheduler.singleton.every "#{sync_interval.to_i}m", SyncHandler.new, job: true, first: :now
    elsif sync_job
      self.sync_job = nil
    end
  end

  def set_or_update_appoint_job
    return unless avoid_scheduler?

    appointment_reset_job&.unschedule

    if appoint_begin_at.present? && first_at = Time.zone.parse(appoint_begin_at)
      if first_at.past?
        if Time.now > Time.zone.parse(appoint_end_at)
          first_at = first_at.tomorrow
        else
          first_at = :now
        end
      end

      if first_at == :now
        self.appointment_reset_job = Rufus::Scheduler.singleton.every '1d'.freeze, AppointmentResetHandler.new, first: :now, job: true
      else
        self.appointment_reset_job = Rufus::Scheduler.singleton.every '1d'.freeze, AppointmentResetHandler.new, first_at: first_at, job: true
      end
    else
      self.appointment_reset_job = nil
    end
  end

  def avoid_scheduler?
    Rails.env.test? || defined?(Rails::Console)
  end

  def update_singleton
    self.setting = self
  end
end
