class SyncHandler
  def call(job, time)
    Rails.logger.info "Scheduler:* #{time} - Handler SyncHandler called for #{job.id}"

    res1 = ::MachineService.new.number_count
    res2 = ::MachineService.new.pass_count
    if res1 && res2
      Setting.total_number_count = res1[:qcount]
      Setting.pass_number_count = res2[:qcount]
    else
      Rails.logger.warn "Failed to get number_count and pass_count!"
    end
  end
end
