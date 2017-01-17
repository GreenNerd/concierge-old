class SettingsController < ApplicationController
  before_action :set_current_setting

  def show
    @page_title = '设置'
  end

  def update
    if @setting.update setting_params
      flash[:success] = '更新成功'
    else
      flash[:error] = '更新失败'
    end

    redirect_to settings_path
  end

  private

  def set_current_setting
    @setting = Setting.first
  end

  def setting_params
    params.require(:setting).permit(:trans_code,
                                    :inst_no,
                                    :term_no,
                                    :counter_counter,
                                    :enable)
  end
end
