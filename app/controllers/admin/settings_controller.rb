class Admin::SettingsController < Admin::ApplicationController
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
    params.require(:setting).permit(:inst_no,
                                    :term_no,
                                    :counter_counter,
                                    :enable,
                                    :mip,
                                    :advance_reservation_days,
                                    :limitation,
                                    :sync_interval,
                                    :appoint_begin_at,
                                    :appoint_end_at,
                                    :openid_server,
                                    :a_text,
                                    :a_appointments_count,
                                    :b_text)
  end
end
