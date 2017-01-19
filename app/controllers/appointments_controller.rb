class AppointmentsController < ApplicationController
  before_action :find_appointment, only: [:new]

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.create appointment_params

    if @appointment.persisted?
      cookies.permanent.signed[:appointment_id] = @appointment.id
    end

    render layout: false
  end

  def show
    @appointment = Appointment.find_by(expired: false, id_number: params[:id_number])
    redirect_to root_path unless @appointment
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
