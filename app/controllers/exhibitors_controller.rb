class ExhibitorsController < ApplicationController

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @exhibitors = ordered_by_name
  end

  def new
    @exhibitor = Exhibitor.new
  end

  def create
    @exhibitor = Exhibitor.new(params[:exhibitor])

    if @exhibitor.valid?
      @exhibitor.save!

      @exhibitor.register_for_show(@current_show, params[:lines], params[:associates]) if params[:attending_current_show] == 'yes'

      @exhibitors = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @exhibitor = Exhibitor.find(params[:id])
  end

  def update
    @exhibitor = Exhibitor.find(params[:id])

    if @exhibitor.update_attributes(params[:exhibitor])
      @exhibitor.shows << @current_show if params[:attending_current_show] == 'yes'
      @exhibitors = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @exhibitor = Exhibitor.find(params[:id])
  end

  def destroy
    @exhibitor = Exhibitor.find(params[:id])

    @exhibitor.destroy

    @exhibitors = ordered_by_name

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @exhibitors = ordered_by_name
  end

  private

  def ordered_by_name
    if @search.blank?
      Exhibitor.ordered_by_name.paginate(:page => params[:page])
    else
      Exhibitor.filtered(@search).ordered_by_name.paginate(:page => params[:page])
    end
  end

end
