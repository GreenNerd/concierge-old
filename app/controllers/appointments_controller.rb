class AppointmentsController < ApplicationController
  before_action :find_appointment, only: [:new, :index]
  before_action :store_openid, only: [:index]

  def index
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.create appointment_params

    render layout: false
  end

  def show
    @appointment = Appointment.find_by(expired: false, id_number: params[:id_number])

    cookies.permanent.signed[:appointment_id] = @appointment.id if @appointment

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

  private

  def appointment_params
    params.require(:appointment).permit(:appoint_at, :business_category_id, :id_number, :phone_number)
  end

  def find_appointment
    @appointment = Appointment.find_by(expired: false, id: cookies.signed[:appointment_id])
    redirect_to appointment_path(@appointment) if @appointment
  end

  def store_openid
    cookies.permanent.signed[:user_openid] = params[:user_openid] if params[:user_openid]
  end
end
