class SyncHandler
  def call(job, time)
    Rails.logger.info "Scheduler:* #{time} - Handler SyncHandler called for #{job.id}"

    service = ::MachineService.new

    3.times do |n|
      number_count_rsp = service.number_count(0)
      pass_count_rsp = service.pass_count(0)

      if number_count_rsp && pass_count_rsp
        Setting.total_number_count = number_count_rsp.dig :package, :qcount
        Setting.pass_number_count = number_count_rsp.dig :package, :qcount
        break
      else
        Rails.logger.warn "SyncHandler: Failed to get number_count and pass_count! Retry #{n}"
      end
    end
  end
end
