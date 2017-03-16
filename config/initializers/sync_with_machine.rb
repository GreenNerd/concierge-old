unless defined?(Rails::Console) || File.split($PROGRAM_NAME).last == 'rake'.freeze || Rails.env.test? || ENV['DISABLE_SCHEDULE_WARMUP'.freeze]
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task

  Rails.logger.info 'Warmup schedule'.freeze
  Setting.warmup
end
