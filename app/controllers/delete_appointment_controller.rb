class DeleteAppointmentController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'secret'

  def index
    @appointments = Appointment.all
  end
end
