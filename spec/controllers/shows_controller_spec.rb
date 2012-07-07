require 'spec_helper'

describe ShowsController do

  before(:each) do
    @venue = FactoryGirl.create(:venue)
    @coordinator = FactoryGirl.create(:coordinator)
    @show1 = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)
  end

  it "should render the index template for the index page" do
    get :index

    shows = assigns[:shows]
    shows.should_not be nil
    shows.size.should be 1

    search = assigns[:search]
    search.blank?.should be_true

    response.should be_success
    response.should render_template(:index)
  end

  it "should display a form to allow the user to create a new show" do
    get :new

    show = assigns[:show]
    show.should_not be nil
    
    response.should be_success
    response.should render_template(:new)
  end

  it "should allow a new show to be created" do
    post :create, { :show => { :name => 'Show 1',
        :start_date => '2011-03-05',
        :end_date => '2011-03-06',
        :next_start_date => '2011-09-10',
        :next_end_date => '2011-09-11',
        :venue_id => @venue.id.to_s,
        :coordinator_id => @coordinator.id.to_s} }
    
    show = assigns[:show]
    show.should_not be_nil

    shows = assigns[:shows]
    shows.should_not be_nil
    shows.size.should be 2 # The newly created one and the one created in 'begin'

    response.should render_template(:new)
  end

  it "should display a form to allow the user to edit an existing show" do
    get :edit, { :id => @show1.id }
    
    show = assigns[:show]
    show.should_not be nil
    show.id.should == @show1.id
    show.name.should == @show1.name
    show.start_date.should == @show1.start_date
    show.end_date.should == @show1.end_date
    show.next_start_date.should == @show1.next_start_date
    show.next_end_date.should == @show1.next_end_date
    show.venue_id.should == @show1.venue_id
    show.coordinator_id.should == @show1.coordinator_id

    response.should be_success
    response.should render_template(:edit)
  end

  it "should allow an existing show to be edited" do
    put :update, { :id => @show1.id,
      :show => {
        :name => "#{@show1.name}_1",
        :start_date => @show1.start_date.strftime("%Y-%m-%d"),
        :end_date => @show1.end_date.strftime("%Y-%m-%d"),
        :next_start_date => @show1.next_start_date.strftime("%Y-%m-%d"),
        :next_end_date => @show1.next_end_date.strftime("%Y-%m-%d"),
        :venue_id => @show1.venue_id,
        :coordinator_id => @show1.coordinator_id
         } }

    show = assigns[:show]
    show.should_not be nil
    show.id.should == @show1.id
    show.name.should == "#{@show1.name}_1"
    show.start_date.should == @show1.start_date
    show.end_date.should == @show1.end_date
    show.next_start_date.should == @show1.next_start_date
    show.next_end_date.should == @show1.next_end_date
    show.venue_id.should == @show1.venue_id
    show.coordinator_id.should == @show1.coordinator_id

    shows = assigns[:shows]
    shows.should_not be_nil
    shows.size.should be 1

    response.should render_template(:edit)

    # Verify that the changes have been saved
    show = Show.find(@show1.id)
    show.id.should == @show1.id
    show.name.should == "#{@show1.name}_1"
    show.start_date.should == @show1.start_date
    show.end_date.should == @show1.end_date
    show.next_start_date.should == @show1.next_start_date
    show.next_end_date.should == @show1.next_end_date
    show.venue_id.should == @show1.venue_id
    show.coordinator_id.should == @show1.coordinator_id
  end

  it "should display the information for a specific show" do
    get :show, { :id => @show1.id }

    show = assigns[:show]
    show.should_not be_nil
    show.id.should == @show1.id

    response.should be_success
    response.should render_template(:show)
  end

  it "should allow an existing show to be deleted" do
    delete :destroy, { :id => @show1.id }

    response.should render_template(:show)

    show = assigns[:show]
    show.should_not be_nil

    shows = assigns[:shows]
    shows.should_not be_nil
    shows.empty?.should be_true

    # Make sure the venue was actually destroyed
    show = Show.find_by_id(@show1.id)
    show.should be_nil
  end
end
