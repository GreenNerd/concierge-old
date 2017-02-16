class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_station

  def current_station
    @current_station ||= Setting::STATIONS.fetch(params[:station]&.to_sym){ Setting::STATIONS[:a] }
  end

  private

  def check_openid
    session[:openid] = params[:openid] if params[:openid].present?

    if session[:openid]
      redirect_uri = session.delete :redirect_uri
      redirect_to redirect_uri if redirect_uri
    else
      session[:redirect_uri] = request.url
      redirect_to "#{Setting.instance.openid_server}?redirect_uri=#{request.url}"
    end
  end
end
