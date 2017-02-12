class AppointmentsController < ApplicationController
  before_action :check_openid
  before_action :detect_appointment, only: [:new, :index]

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

  def query
    respond_to do |format|
      format.html
      format.js do
        @appointment = Appointment.find_by(expired: false, id_number: params[:query])
        render layout: false
      end
    end
  end

  def destroy
    @appointment = Appointment.find_by id: params[:id]
    @appointment.destroy if @appointment

    respond_to do |format|
      format.html { redirect_to admin_removeappointment_path }
      format.js { render layout: false }
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
end
