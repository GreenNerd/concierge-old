class Admin::SettingsController < AdminController

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
    params.require(:setting).permit(:tran_code,
                                    :inst_no,
                                    :term_no,
                                    :counter_counter,
                                    :enable,
                                    :mip,
                                    :limitation,
                                    :sync_interval,
                                    :appoint_begin_at)
  end
end
