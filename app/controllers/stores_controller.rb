class StoresController < ApplicationController
  include CrudSearches

  crud_model Store
  order_scope :ordered_by_name

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @stores = ordered_results
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.valid?
      @store.save!
      @stores = ordered_results
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
      @stores = ordered_results
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

    @stores = ordered_results

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @stores = ordered_results
  end

end
