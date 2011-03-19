class VenuesController < ApplicationController
  include CrudSearches

  crud_model Venue
  order_scope :ordered_by_name

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @venues = ordered_results
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])

    if @venue.valid?
      @venue.save!
      @venues = ordered_results
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update_attributes(params[:venue])
      @venues = ordered_results
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def destroy
    @venue = Venue.find(params[:id])

    @venue.destroy

    @venues = ordered_results

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @venues = ordered_results
  end

end