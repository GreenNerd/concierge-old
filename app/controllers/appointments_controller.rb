class AppointmentsController < ApplicationController
  before_action :check_openid
  before_action :detect_appointment, only: [:new, :index]
  before_action :check_enable, only: [:new, :create, :index]

  def index
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.create appointment_params.merge({ openid: session[:openid] })

    render layout: false
  end

  def show
    @appointment = Appointment.find_by(expired: false, openid: session[:openid])

    redirect_to root_path unless @appointment
  end

  def closed
    redirect_to action: :index if Setting.instance.enable?
  end

  def query
    respond_to do |format|
      format.html
      format.js do
        @appointment = Appointment.find_by(expired: false, id_number: params[:query])
        render layout: false
      end
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:appoint_at, :business_category_id, :id_number, :phone_number)
  end

  def detect_appointment
    @appointment = Appointment.find_by(expired: false, openid: session[:openid])
    redirect_to appointment_path(@appointment) if @appointment
  end

  def check_enable
    redirect_to action: :closed unless Setting.instance.enable?
  end
end
