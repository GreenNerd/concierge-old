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

  validates :advance_reservation_days, numericality: { only_integer: true, greater_than: 1 }

  after_update_commit :set_or_update_sync_job, if: lambda { |s| s.previous_changes.include?(:sync_interval) }
  after_update_commit :set_or_update_appointment_reset_job, if: lambda { |s| s.previous_changes.include?(:appoint_begin_at) }

  after_commit :update_singleton

  def self.instance
    self.setting ||= first_or_create
  end

  def self.warmup
    instance.set_or_update_appointment_reset_job
    instance.set_or_update_sync_job
  end

  def appoint_begin_at
    Time.zone.parse read_attribute(:appoint_begin_at).to_s
  end

  def appoint_end_at
    Time.zone.parse read_attribute(:appoint_end_at).to_s
  end

  def wait_number_count
    total_number_count.to_i - pass_number_count.to_i
  end

  def set_or_update_sync_job
    return if avoid_scheduler?

    sync_job&.unschedule

    if sync_interval.present?
      update sync_job_id: Rufus::Scheduler.singleton.every("#{sync_interval.to_i}m", SyncHandler.new, first: :now)
    elsif sync_job
      update sync_job_id: nil
    end
  end

  def set_or_update_appointment_reset_job
    return if avoid_scheduler?

    appointment_reset_job&.unschedule

    if appoint_begin_at?
      if appoint_begin_at.past?
        first_at = if appoint_end_at && Time.zone.now > appoint_end_at
                     appoint_begin_at.tomorrow
                   else
                     :now
                   end
      end

      update appointment_reset_job_id: Rufus::Scheduler.singleton.every('1d'.freeze, AppointmentResetHandler.new, first_at: first_at)
    else
      update appointment_reset_job_id: nil
    end
  end

  def in_window_time?
    return unless appoint_begin_at.present?
    return unless appoint_end_at.present?

    appoint_begin_at <= Time.zone.now && Time.zone.now <= appoint_end_at
  end

  def avoid_scheduler?
    Rails.env.test? || defined?(Rails::Console)
  end

  def update_singleton
    self.setting = self
  end

  def sync_job
    sync_job_id && Rufus::Scheduler.singleton.job(sync_job_id)
  end

  def appointment_reset_job
    appointment_reset_job_id && Rufus::Scheduler.singleton.job(appointment_reset_job_id)
  end
end
