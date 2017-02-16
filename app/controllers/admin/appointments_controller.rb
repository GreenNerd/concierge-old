class Admin::AppointmentsController < Admin::ApplicationController
  before_action :set_appointment, only: [:show, :destroy]

  def index
  end

  def show
  end

  def destroy
    @appointment.destroy
    redirect_to action: :index
  end

  private

  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])
    redirect_to action: :index unless @appointment
  end
end
