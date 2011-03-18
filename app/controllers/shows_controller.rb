class ShowsController < ApplicationController

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @shows = ordered_by_most_recent
  end

  def new
    @show = Show.new
    @show.set_default_show_dates
    @coordinators = Coordinator.ordered_by_name
    @venues = Venue.ordered_by_name
  end

  def create
    @show = Show.new(params[:show])

    if @show.valid?
      @show.save!
      @shows = ordered_by_most_recent
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @show = Show.find(params[:id])
    @coordinators = Coordinator.ordered_by_name
    @venues = Venue.ordered_by_name
  end

  def update
    @show = Show.find(params[:id])

    if @show.update_attributes(params[:show])
      @shows = ordered_by_most_recent
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @show = Show.find(params[:id])
  end

  def destroy
    @show = Show.find(params[:id])

    @show.destroy

    @shows = ordered_by_most_recent

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @shows = ordered_by_most_recent
  end

  def set_current_show
    show = params[:show_id]
    session[:current_show] = show.to_i if show
    redirect_to "/"
  end

  private

  def ordered_by_most_recent
    if @search.blank?
      Show.ordered_by_most_recent.paginate(:page => params[:page])
    else
      Show.filtered(@search).ordered_by_most_recent.paginate(:page => params[:page])
    end
  end


end