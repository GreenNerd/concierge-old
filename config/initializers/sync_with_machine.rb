unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env.test?
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task

  Setting.instance.set_or_update_appoint_job
  Setting.instance.set_or_update_sync_job
end
