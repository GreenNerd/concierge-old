class SettingsController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'secret'

  layout 'admin'.freeze

  before_action :set_current_setting

  def show
    @page_title = '设置'
  end

  def update
    @updated = @setting.update(setting_params)
    render layout: false
  end

  private

  def set_current_setting
    @setting = Setting.instance
  end

  def setting_params
    params.require(:setting).permit(:trans_code,
                                    :inst_no,
                                    :term_no,
                                    :counter_counter,
                                    :enable,
                                    :mip,
                                    :limitation)
  end
end
