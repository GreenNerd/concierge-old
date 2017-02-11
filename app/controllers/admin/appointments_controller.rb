class AppointmentController < AdminController
  def index
    @appointments = Appointment.all
  end
end
