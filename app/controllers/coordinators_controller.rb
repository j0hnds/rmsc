class CoordinatorsController < ApplicationController

  layout 'primary', :only => [ :index ]

  def index
    @coordinators = ordered_by_name
    @search = get_search_term
  end

  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new(params[:coordinator])
    
    if @coordinator.valid?
      @coordinator.save!
      @coordinators = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @coordinator = Coordinator.find(params[:id])
  end

  def update
    @coordinator = Coordinator.find(params[:id])

    if @coordinator.update_attributes(params[:coordinator])
      @coordinators = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @coordinator = Coordinator.find(params[:id])
  end

  def destroy
    coordinator = Coordinator.find(params[:id])

    coordinator.destroy

    redirect_to coordinators_path
  end

  def search
    @search = get_search_term
    @coordinators = ordered_by_name
    render :action => :list_only
  end

  private

  def ordered_by_name
    if @search.blank?
      Coordinator.ordered_by_name.paginate(:page => params[:page], :per_page => 5)
    else
      Coordinator.filtered(@search).ordered_by_name.paginate(:page => params[:page], :per_page => 5)
    end
  end

end
