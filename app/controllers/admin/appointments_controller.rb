class Admin::AppointmentsController < Admin::ApplicationController
  def index
    @appointments = Appointment.all
  end
end
