class Admin::AvailabilitiesController < Admin::ApplicationController

  layout 'admin'.freeze

  def index
    @availabilities = Availability.order(effective_date: :asc)
    @availability = Availability.new
  end

  def create
    @availability = Availability.create availability_params
    render layout: false
  end

  def destroy
    @availability = Availability.find_by id: params[:id]
    @availability.destroy if @availability

    render action: index
  end

  private

  def availability_params
    params.require(:availability).permit(:effective_date, :available)
  end
end
