class VenuesController < ApplicationController

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @venues = ordered_by_name
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])

    if @venue.valid?
      @venue.save!
      @venues = ordered_by_name
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
      @venues = ordered_by_name
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

    @venues = ordered_by_name

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @venues = ordered_by_name
  end

  private

  def ordered_by_name
    if @search.blank?
      Venue.ordered_by_name.paginate(:page => params[:page])
    else
      Venue.filtered(@search).ordered_by_name.paginate(:page => params[:page])
    end
  end


end