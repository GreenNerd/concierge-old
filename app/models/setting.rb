class Setting < ApplicationRecord
  STATIONS = {
    a: {
      name: '政务服务大厅',
      address: '成都市天府大道18号高新国际广场A座3楼'
    },
    b: {
      name: '企业注册中心',
      address: '成都市天府大道18号高新国际广场E座2楼201'
    }
  }.freeze

  cattr_accessor :setting

  cattr_accessor :sync_job
  cattr_accessor :appointment_reset_job
  cattr_accessor :total_number_count
  cattr_accessor :pass_number_count

  validates :advance_reservation_days, numericality: { only_integer: true, greater_than: 1 }

  after_update_commit :set_or_update_sync_job, if: lambda { |s| s.previous_changes.include?(:sync_interval) }
  after_update_commit :set_or_update_appointment_reset_job, if: lambda { |s| s.previous_changes.include?(:appoint_begin_at) }

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
    return if avoid_scheduler?

    sync_job&.unschedule

    if sync_interval.present?
      self.sync_job = Rufus::Scheduler.singleton.every "#{sync_interval.to_i}m", SyncHandler.new, job: true, first: :now
    elsif sync_job
      self.sync_job = nil
    end
  end

  def set_or_update_appointment_reset_job
    return if avoid_scheduler?

    appointment_reset_job&.unschedule

    if first_at = Time.zone.parse(appoint_begin_at.to_s)
      if first_at.past?
        first_at = if Time.zone.parse(appoint_end_at.to_s) && Time.zone.now > Time.zone.parse(appoint_end_at.to_s)
                     first_at.tomorrow
                   else
                     :now
                   end
      end

      self.appointment_reset_job = Rufus::Scheduler.singleton.every '1d'.freeze, AppointmentResetHandler.new, first_at: first_at, job: true
    else
      self.appointment_reset_job = nil
    end
  end

  def in_window_time?
    begin_at = Time.zone.parse(appoint_begin_at.to_s)
    return unless begin_at.present?

    end_at = Time.zone.parse(appoint_end_at.to_s)
    return unless end_at.present?

    begin_at <= Time.zone.now && Time.zone.now <= end_at
  end

  def avoid_scheduler?
    Rails.env.test? || defined?(Rails::Console)
  end

  def update_singleton
    self.setting = self
  end
end
