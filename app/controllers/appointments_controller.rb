class AppointmentsController < ApplicationController
  before_action :find_appointment, only: [:new, :index]

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

  def destroy
    @appointment = Appointment.find_by params[:id]
    @appointment.destroy if @appointment

    render action: index
  end

  private

  def appointment_params
    params.require(:appointment).permit(:appoint_at, :business_category_id, :id_number, :phone_number)
  end

  def find_appointment
    @appointment = Appointment.find_by(expired: false, id: cookies.signed[:appointment_id])
    redirect_to appointment_path(@appointment) if @appointment
  end
end
