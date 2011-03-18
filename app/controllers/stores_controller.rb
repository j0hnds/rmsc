class StoresController < ApplicationController

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @stores = ordered_by_name
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.valid?
      @store.save!
      @stores = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])

    if @store.update_attributes(params[:store])
      @stores = ordered_by_name
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @store = Store.find(params[:id])
  end

  def destroy
    @store = Store.find(params[:id])

    @store.destroy

    @stores = ordered_by_name

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @stores = ordered_by_name
  end

  private

  def ordered_by_name
    if @search.blank?
      Store.ordered_by_name.paginate(:page => params[:page])
    else
      Store.filtered(@search).ordered_by_name.paginate(:page => params[:page])
    end
  end

end
