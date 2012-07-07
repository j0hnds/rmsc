require 'spec_helper'

describe ExhibitorsController do

  before(:each) do
    @exhibitor1 = FactoryGirl.create(:exhibitor)
  end

  it "should render the index template for the index page" do
    get :index

    exhibitors = assigns[:exhibitors]
    exhibitors.should_not be nil
    exhibitors.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new exhibitor" do
    get :new

    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new exhibitor to be created" do
    post :create, { :exhibitor => { :first_name => 'Harrold',
        :last_name => 'Jones',
        :address => '123 Main',
        :city => 'ATown',
        :state => 'WA',
        :postal_code => '00000',
        :phone => '303 999 9999',
        :email => 'harrold.jones@email.com' } }
    
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be_nil

    exhibitors = assigns[:exhibitors]
    exhibitors.should_not be_nil
    exhibitors.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing exhibitor" do
    get :edit, { :id => @exhibitor1.id }
    
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.id.should == @exhibitor1.id
    exhibitor.first_name.should == @exhibitor1.first_name
    exhibitor.last_name.should == @exhibitor1.last_name
    exhibitor.address.should == @exhibitor1.address
    exhibitor.city.should == @exhibitor1.city
    exhibitor.state.should == @exhibitor1.state
    exhibitor.phone.should == @exhibitor1.phone
    exhibitor.fax.should == @exhibitor1.fax
    exhibitor.cell.should == @exhibitor1.cell
    exhibitor.email.should == @exhibitor1.email

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing exhibitor to be edited" do
    put :update, { :id => @exhibitor1.id,
      :exhibitor => {
        :first_name => @exhibitor1.first_name,
        :last_name => "#{@exhibitor1.last_name}_1",
        :address => @exhibitor1.address,
        :city => @exhibitor1.city,
        :state => @exhibitor1.state,
        :postal_code => @exhibitor1.postal_code,
        :phone => "909 999 9999",
        :fax => @exhibitor1.fax,
        :cell => @exhibitor1.cell,
        :email => @exhibitor1.email } }

    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.id.should == @exhibitor1.id
    exhibitor.first_name.should == @exhibitor1.first_name
    exhibitor.last_name.should == "#{@exhibitor1.last_name}_1"
    exhibitor.address.should == @exhibitor1.address
    exhibitor.city.should == @exhibitor1.city
    exhibitor.state.should == @exhibitor1.state
    exhibitor.postal_code.should == @exhibitor1.postal_code
    exhibitor.phone.should == "909 999 9999"
    exhibitor.fax.should == @exhibitor1.fax
    exhibitor.cell.should == @exhibitor1.cell
    exhibitor.email.should == @exhibitor1.email

    exhibitors = assigns[:exhibitors]
    exhibitors.should_not be_nil
    exhibitors.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    exhibitor = Exhibitor.find(@exhibitor1.id)
    exhibitor.id.should == @exhibitor1.id
    exhibitor.first_name.should == @exhibitor1.first_name
    exhibitor.last_name.should == "#{@exhibitor1.last_name}_1"
    exhibitor.address.should == @exhibitor1.address
    exhibitor.city.should == @exhibitor1.city
    exhibitor.state.should == @exhibitor1.state
    exhibitor.postal_code.should == @exhibitor1.postal_code
    exhibitor.phone.should == "909 999 9999"
    exhibitor.fax.should == @exhibitor1.fax
    exhibitor.cell.should == @exhibitor1.cell
    exhibitor.email.should == @exhibitor1.email
  end

  it "should display the information for a specific exhibitor" do
    get :show, { :id => @exhibitor1.id }

    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be_nil
    exhibitor.id.should == @exhibitor1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing exhibitor to be deleted" do
    delete :destroy, { :id => @exhibitor1.id }

    response.should render_template(:show)

    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be_nil

    exhibitors = assigns[:exhibitors]
    exhibitors.should_not be_nil
    exhibitors.empty?.should be_true

    # Make sure the exhibitor was actually destroyed
    exhibitor = Exhibitor.find_by_id(@exhibitor1.id)
    exhibitor.should be_nil
  end
  
end
