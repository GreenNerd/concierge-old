s = Rufus::Scheduler.singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake'
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task

  s.cron '00 00 * * *' do
    Appointment.where("appoint_at >= '#{Date.today}'")
               .where("appoint_at < '#{Date.tomorrow}'")
               .find_each do |appointment|
                res = appointment.create_number

                if res
                  appointment.update_columns queue_number: res[:queue_number]
                else
                  Rails.logger.warn "Failed to create number for Appointment ##{appointment.id}"
                end
               end
  end
end
