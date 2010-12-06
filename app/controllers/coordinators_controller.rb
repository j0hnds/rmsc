class CoordinatorsController < ApplicationController

  layout 'primary', :only => [ :index ]

  def index
    @coordinators = Coordinator.ordered_by_name.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new(params[:coordinator])
    
    if @coordinator.valid?
      @coordinator.save!
      # redirect_to coordinators_path and return
      render :action => :success and return if request.xhr?
    end

    render :action => failure and return if request.xhr?

    render :new
  end

  def edit
    @coordinator = Coordinator.find(params[:id])
  end

  def update
    @coordinator = Coordinator.find(params[:id])

    if @coordinator.update_attributes(params[:coordinator])
      redirect_to coordinators_path and return
    end

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

end
