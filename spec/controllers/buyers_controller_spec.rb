require 'spec_helper'

describe BuyersController do


  before(:each) do
    @store = Factory.create(:store)
    @buyer1 = Factory.create(:buyer, :store => @store)
  end

  it "should render the index template for the index page" do
    get :index

    buyers = assigns[:buyers]
    buyers.should_not be nil
    buyers.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new buyer" do
    get :new

    buyer = assigns[:buyer]
    buyer.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new buyer to be created" do
    post :create, { :buyer => { :first_name => 'Harrold',
        :last_name => 'Jones',
        :phone => '303 999 9999',
        :email => 'harrold.jones@email.com',
        :store_id => @store.id.to_s } }
    
    buyer = assigns[:buyer]
    buyer.should_not be_nil

    buyers = assigns[:buyers]
    buyers.should_not be_nil
    buyers.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing buyer" do
    get :edit, { :id => @buyer1.id }
    
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.id.should == @buyer1.id
    buyer.first_name.should == @buyer1.first_name
    buyer.last_name.should == @buyer1.last_name
    buyer.phone.should == @buyer1.phone
    buyer.email.should == @buyer1.email

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing buyer to be edited" do
    put :update, { :id => @buyer1.id,
      :buyer => { 
        :first_name => @buyer1.first_name,
        :last_name => "#{@buyer1.last_name}_1",
        :phone => "909 999 9999",
        :email => @buyer1.email } }

    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.id.should == @buyer1.id
    buyer.first_name.should == @buyer1.first_name
    buyer.last_name.should == "#{@buyer1.last_name}_1"
    buyer.phone.should == "909 999 9999"
    buyer.email.should == @buyer1.email

    buyers = assigns[:buyers]
    buyers.should_not be_nil
    buyers.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    buyer = Buyer.find(@buyer1.id)
    buyer.id.should == @buyer1.id
    buyer.first_name.should == @buyer1.first_name
    buyer.last_name.should == "#{@buyer1.last_name}_1"
    buyer.phone.should == "909 999 9999"
    buyer.email.should == @buyer1.email
  end

  it "should display the information for a specific buyer" do
    get :show, { :id => @buyer1.id }

    buyer = assigns[:buyer]
    buyer.should_not be_nil
    buyer.id.should == @buyer1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing buyer to be deleted" do
    delete :destroy, { :id => @buyer1.id }

    response.should render_template(:show)

    buyer = assigns[:buyer]
    buyer.should_not be_nil

    buyers = assigns[:buyers]
    buyers.should_not be_nil
    buyers.empty?.should be_true

    # Make sure the buyer was actually destroyed
    buyer = Buyer.find_by_id(@buyer1.id)
    buyer.should be_nil
  end
end
