class Admin::AvailabilitiesController < Admin::ApplicationController
  def index
    @availabilities = Availability.order(effective_date: :asc)
    @availability = Availability.new
  end

  def create
    @availability = Availability.create availability_params
    render layout: false
  end

  def destroy
    @availability = Availability.find params[:id]
    @availability.destroy if @availability

    render layout: false
  end

  private

  def availability_params
    params.require(:availability).permit(:effective_date, :available)
  end
end
