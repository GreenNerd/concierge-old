unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env.test?
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task

  Setting.warmup
end
