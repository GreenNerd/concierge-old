class SyncHandler
  def call(job, time)
    Rails.logger.info "Scheduler:* #{time} - Handler SyncHandler called for #{job.id}"

    service = ::MachineService.new

    number_count_rsp = service.number_count(0)
    if number_count_rsp
      Setting.total_number_count = number_count_rsp.dig :package, :qcount
    else
      Rails.logger.warn "SyncHandler: Failed to get number_count!"
    end

    pass_count_rsp = service.pass_count(0)
    if pass_count_rsp
      Setting.pass_number_count = pass_count_rsp.dig :package, :qcount
    else
      Rails.logger.warn "SyncHandler: Failed to get pass_count!"
    end

    BusinessCounter.find_each do |counter|
      rsp = service.serving_number(0, counter.number)
      if rsp
        counter.update serving_number: rsp.dig(:package, :queue_number)
      else
        Rails.logger.warn "SyncHandler: Failed to get serving_number of Counter ##{counter.id}!"
      end
    end
  end
end
