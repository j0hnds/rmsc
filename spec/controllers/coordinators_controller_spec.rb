require 'spec_helper'

describe CoordinatorsController do

  before(:each) do
    @coordinator1 = FactoryGirl.create(:coordinator)
  end

  it "should render the index template for the index page" do
    get :index

    coordinators = assigns[:coordinators]
    coordinators.should_not be nil
    coordinators.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new coordinator" do
    get :new

    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new coordinator to be created" do
    post :create, { :coordinator => { :first_name => 'Harrold',
        :last_name => 'Jones',
        :phone => '303 999 9999',
        :email => 'harrold.jones@email.com' } }
    
    coordinator = assigns[:coordinator]
    coordinator.should_not be_nil

    coordinators = assigns[:coordinators]
    coordinators.should_not be_nil
    coordinators.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing coordinator" do
    get :edit, { :id => @coordinator1.id }
    
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.id.should == @coordinator1.id
    coordinator.first_name.should == @coordinator1.first_name
    coordinator.last_name.should == @coordinator1.last_name
    coordinator.phone.should == @coordinator1.phone
    coordinator.email.should == @coordinator1.email

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing coordinator to be edited" do
    put :update, { :id => @coordinator1.id,
      :coordinator => { 
        :first_name => @coordinator1.first_name,
        :last_name => "#{@coordinator1.last_name}_1",
        :phone => "909 999 9999",
        :email => @coordinator1.email } }

    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.id.should == @coordinator1.id
    coordinator.first_name.should == @coordinator1.first_name
    coordinator.last_name.should == "#{@coordinator1.last_name}_1"
    coordinator.phone.should == "909 999 9999"
    coordinator.email.should == @coordinator1.email

    coordinators = assigns[:coordinators]
    coordinators.should_not be_nil
    coordinators.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    coordinator = Coordinator.find(@coordinator1.id)
    coordinator.id.should == @coordinator1.id
    coordinator.first_name.should == @coordinator1.first_name
    coordinator.last_name.should == "#{@coordinator1.last_name}_1"
    coordinator.phone.should == "909 999 9999"
    coordinator.email.should == @coordinator1.email
  end

  it "should display the information for a specific coordinator" do
    get :show, { :id => @coordinator1.id }

    coordinator = assigns[:coordinator]
    coordinator.should_not be_nil
    coordinator.id.should == @coordinator1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing coordinator to be deleted" do
    delete :destroy, { :id => @coordinator1.id }

    response.should render_template(:show)

    coordinator = assigns[:coordinator]
    coordinator.should_not be_nil

    coordinators = assigns[:coordinators]
    coordinators.should_not be_nil
    coordinators.empty?.should be_true

    # Make sure the coordinator was actually destroyed
    coordinator = Coordinator.find_by_id(@coordinator1.id)
    coordinator.should be_nil
  end
end
