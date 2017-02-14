class SyncHandler
  def call(job, time)
    Rails.logger.info "Scheduler:* #{time} - Handler SyncHandler called for #{job.id}"

    service = ::MachineService.new

    3.times do |n|
      number_count_rsp = service.number_count(0)
      pass_count_rsp = service.pass_count(0)

      if number_count_rsp && pass_count_rsp
        Setting.total_number_count = number_count_rsp.dig :package, :qcount
        Setting.pass_number_count = pass_count_rsp.dig :package, :qcount
        break
      else
        Rails.logger.warn "SyncHandler: Failed to get number_count and pass_count! Retry #{n}"
      end
    end

    BusinessCounter.find_each do |counter|
      3.times do |n|
        rsp = service.serving_number(0, counter.number)
        if rsp
          counter.update serving_number: rsp.dig(:package, :queue_number)
          break
        else
          Rails.logger.warn "SyncHandler: Failed to get serving_number of Counter ##{counter.id}! Retry #{n}"
        end
      end
    end
  end
end
