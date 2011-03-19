class BuyersController < ApplicationController
  include CrudSearches

  crud_model Buyer
  order_scope :ordered_by_name

  layout 'primary', :only => [ :index ]

  before_filter :get_search_term, :only => [ :index, :create, :update, :destroy, :search ]

  def index
    @buyers = ordered_results
  end

  def new
    @buyer = Buyer.new
    @stores = Store.ordered_by_name
  end

  def create
    @buyer = Buyer.new(params[:buyer])

    if @buyer.valid?
      @buyer.save!
      @buyers = ordered_results
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :new
  end

  def edit
    @buyer = Buyer.find(params[:id])
    @stores = Store.ordered_by_name
  end

  def update
    @buyer = Buyer.find(params[:id])

    if @buyer.update_attributes(params[:buyer])
      @buyers = ordered_results
      render :action => :success and return if request.xhr?
    end

    render :action => :failure and return if request.xhr?

    render :edit
  end

  def show
    @buyer = Buyer.find(params[:id])
  end

  def destroy
    @buyer = Buyer.find(params[:id])

    @buyer.destroy

    @buyers = ordered_results

    render :action => :success and return if request.xhr?

    render :show
  end

  def search
    @buyers = ordered_results
  end

end
