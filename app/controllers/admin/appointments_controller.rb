class Admin::AppointmentsController < AdminController
  def index
    @appointments = Appointment.all
  end
end
