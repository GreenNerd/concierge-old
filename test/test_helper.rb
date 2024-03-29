ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  setup do
    Timecop.freeze '2017-2-9'
  end

  teardown do
    Timecop.return
  end

  # Add more helper methods to be used by all tests here...
end
