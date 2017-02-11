class SyncHandler
  def call(job, time)
    Rails.logger.info "Scheduler:* #{time} - Handler SyncHandler called for #{job.id}"

    3.times do |n|
      service = ::MachineService.new
      res1 = service.number_count(0)
      res2 = service.pass_count(0)
      if res1 && res2
        Setting.total_number_count = res1.dig :package, :qcount
        Setting.pass_number_count = res2.dig :package, :qcount
        break
      else
        Rails.logger.warn "Failed to get number_count and pass_count! Retry #{n}"
      end
    end
  end
end
