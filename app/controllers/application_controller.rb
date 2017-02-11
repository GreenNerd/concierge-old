class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_openid

  private

  def check_openid
    unless cookies.signed[:user_openid] || params[:user_openid] || Rails.env.test?
      url = 'https://skylarkly.com/wechats/1/openid_disptcher?redirect_uri=https://domain.com'
      redirect_to url
    end
  end
end
