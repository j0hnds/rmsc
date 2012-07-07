require 'spec_helper'

describe VenuesController do

  before(:each) do
    @venue1 = FactoryGirl.create(:venue)
  end

  it "should render the index template for the index page" do
    get :index

    venues = assigns[:venues]
    venues.should_not be nil
    venues.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new venue" do
    get :new

    venue = assigns[:venue]
    venue.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new venue to be created" do
    post :create, { :venue => { :name => 'Harrold',
        :address_1 => 'Jones',
        :city => 'Santa Monica',
        :state => 'SD',
        :postal_code => '00101',
        :phone => '111 111 1111',
        :fax => '222 222 2222' } }
    
    venue = assigns[:venue]
    venue.should_not be_nil

    venues = assigns[:venues]
    venues.should_not be_nil
    venues.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing venue" do
    get :edit, { :id => @venue1.id }
    
    venue = assigns[:venue]
    venue.should_not be nil
    venue.id.should == @venue1.id
    venue.name.should == @venue1.name
    venue.address_1.should == @venue1.address_1
    venue.address_2.should == @venue1.address_2
    venue.city.should == @venue1.city
    venue.state.should == @venue1.state
    venue.postal_code.should == @venue1.postal_code

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing venue to be edited" do
    put :update, { :id => @venue1.id,
      :venue => {
        :name => @venue1.name,
        :address_1 => "#{@venue1.address_1}_1",
        :city => "San Antonio",
        :state => @venue1.state,
        :postal_code => @venue1.postal_code } }

    venue = assigns[:venue]
    venue.should_not be nil
    venue.id.should == @venue1.id
    venue.name.should == @venue1.name
    venue.address_1.should == "#{@venue1.address_1}_1"
    venue.city.should == "San Antonio"
    venue.state.should == @venue1.state
    venue.postal_code.should == @venue1.postal_code

    venues = assigns[:venues]
    venues.should_not be_nil
    venues.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    venue = Venue.find(@venue1.id)
    venue.id.should == @venue1.id
    venue.name.should == @venue1.name
    venue.address_1.should == "#{@venue1.address_1}_1"
    venue.city.should == "San Antonio"
    venue.state.should == @venue1.state
    venue.postal_code.should == @venue1.postal_code
  end

  it "should display the information for a specific venue" do
    get :show, { :id => @venue1.id }

    venue = assigns[:venue]
    venue.should_not be_nil
    venue.id.should == @venue1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing venue to be deleted" do
    delete :destroy, { :id => @venue1.id }

    response.should render_template(:show)

    venue = assigns[:venue]
    venue.should_not be_nil

    venues = assigns[:venues]
    venues.should_not be_nil
    venues.empty?.should be_true

    # Make sure the venue was actually destroyed
    venue = Venue.find_by_id(@venue1.id)
    venue.should be_nil
  end
end
