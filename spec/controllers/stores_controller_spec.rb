require 'spec_helper'

describe StoresController do

  before(:each) do
    @store1 = FactoryGirl.create(:store)
  end

  it "should render the index template for the index page" do
    get :index

    stores = assigns[:stores]
    stores.should_not be nil
    stores.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new store" do
    get :new

    store = assigns[:store]
    store.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new store to be created" do
    post :create, { :store => { :name => 'The Store',
        :phone => '303 999 9999',
        :email => 'harrold.jones@email.com' } }
    
    store = assigns[:store]
    store.should_not be_nil

    stores = assigns[:stores]
    stores.should_not be_nil
    stores.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing store" do
    get :edit, { :id => @store1.id }
    
    store = assigns[:store]
    store.should_not be nil
    store.id.should == @store1.id
    store.name.should == @store1.name
    store.phone.should == @store1.phone
    store.email.should == @store1.email

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing store to be edited" do
    put :update, { :id => @store1.id,
      :store => { 
        :name => "#{@store1.name}_1",
        :phone => "909 999 9999",
        :email => @store1.email } }

    store = assigns[:store]
    store.should_not be nil
    store.id.should == @store1.id
    store.name.should == "#{@store1.name}_1"
    store.phone.should == "909 999 9999"
    store.email.should == @store1.email

    stores = assigns[:stores]
    stores.should_not be_nil
    stores.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    store = Store.find(@store1.id)
    store.id.should == @store1.id
    store.name.should == "#{@store1.name}_1"
    store.phone.should == "909 999 9999"
    store.email.should == @store1.email
  end

  it "should display the information for a specific store" do
    get :show, { :id => @store1.id }

    store = assigns[:store]
    store.should_not be_nil
    store.id.should == @store1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing store to be deleted" do
    delete :destroy, { :id => @store1.id }

    response.should render_template(:show)

    store = assigns[:store]
    store.should_not be_nil

    stores = assigns[:stores]
    stores.should_not be_nil
    stores.empty?.should be_true

    # Make sure the store was actually destroyed
    store = Store.find_by_id(@store1.id)
    store.should be_nil
  end
  
end
