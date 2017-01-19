class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.create appointment_params
    render layout: false
  end

  def show
    @appointment = Appointment.find_by(expired: false, id_number: params[:id_number])
  end

  private

  def appointment_params
    params.require(:appointment).permit(:appoint_at, :business_category_id, :id_number, :phone_number)
  end
end
