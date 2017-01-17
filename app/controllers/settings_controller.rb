class SettingsController < ApplicationController
  def show
    @page_title = '设置'
    @setting = Setting.first
  end
end
