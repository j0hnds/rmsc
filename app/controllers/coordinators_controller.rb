class CoordinatorsController < ApplicationController
  include CrudSearches

  crud_model Coordinator
  order_scope :ordered_by_name

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @coordinators = ordered_results
  end

  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new(params[:coordinator])
    
    if @coordinator.valid?
      @coordinator.save!
      @coordinators = ordered_results
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
      @coordinators = ordered_results
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @coordinator = Coordinator.find(params[:id])
  end

  def destroy
    @coordinator = Coordinator.find(params[:id])

    @coordinator.destroy

    @coordinators = ordered_results

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @coordinators = ordered_results
  end

end
