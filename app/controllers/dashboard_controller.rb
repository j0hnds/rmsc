class DashboardController < ApplicationController

  layout 'primary', :only => [ :index ]

  def index
    @number_of_shows = Show.count
    @number_of_venues = Venue.count
    @number_of_coordinators = Coordinator.count
    @number_of_exhibitors = Exhibitor.count
    @number_of_stores = Store.count
    @number_of_buyers = Buyer.count
  end

end
