class Admin::ApplicationController < ApplicationController
  before_action :authenticate

  layout 'admin'.freeze

  private

  def authenticate
    return if Rails.env.test?

    authenticate_or_request_with_http_digest do |username|
      if username == http_basic_authentication[:username]
        http_basic_authentication[:password]
      end
    end
  end

  def http_basic_authentication
    ActiveSupport::HashWithIndifferentAccess
      .new(Rails.application.config_for(:concierge))
      .fetch(:http_basic_authentication)
  rescue
    {
      username: 'admin',
      password: 'secret'
    }.freeze
  end
end
