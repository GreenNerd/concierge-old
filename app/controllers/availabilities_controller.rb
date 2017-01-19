class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.order(effective_date: :asc)
  end
end
