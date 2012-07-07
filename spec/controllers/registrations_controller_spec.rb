require 'spec_helper'

describe RegistrationsController do

  before(:each) do

    # Create a show
    @venue = FactoryGirl.create(:venue)
    @coordinator = FactoryGirl.create(:coordinator)
    @show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    # Create 3 exhibitors and register them
    exhibitor = FactoryGirl.create(:exhibitor, :first_name => "Zebulon", :last_name => "Pike")
    @show.register_exhibitor(exhibitor, "line 1,line 2")
    exhibitor = FactoryGirl.create(:exhibitor, :first_name => "Rustaceous", :last_name => "Oberon")
    @show.register_exhibitor(exhibitor, nil, "Jim Franklin")
    exhibitor = FactoryGirl.create(:exhibitor, :first_name => "Al", :last_name => "Alano")
    @show.register_exhibitor(exhibitor)
  end

  it "should provide a list of the show registrations" do
    get :index

    registrations = assigns[:exhibitor_registrations]
    registrations.should_not be_nil
    registrations.length.should be 3

    registrations[0].exhibitor.first_name.should == 'Al'
    registrations[1].exhibitor.first_name.should == 'Rustaceous'
    registrations[2].exhibitor.first_name.should == 'Zebulon'
  end

  it "should allow the room number to change for a registration" do
    # which room should change?
    room = @show.registrations.first.rooms.first

    original_room_number = room.room

    post :room, :element_id => room.id, :update_value => "1001a"

    response.should be_success
    response.body.should == "1001a"

    room = Room.find(room.id)
    room.room.should_not == original_room_number
    room.room.should == '1001a'
  end

  it "should allow the lines to change for a registration" do
    room = @show.registrations.second.rooms.first

    original_lines = room.lines_as_csv

    post :lines, :element_id => room.id, :update_value => "aLine1,aLine2,aLine3"

    response.should be_success
    response.body.should == "aLine1,aLine2,aLine3"

    lines = Room.find(room.id).lines_as_csv
    lines.should_not == original_lines
    lines.should == "aLine1,aLine2,aLine3"
  end

  it "should allow the associates to change for a registration" do
    room = @show.registrations.last.rooms.first

    original_associates = room.associates_as_csv

    post :associates, :element_id => room.id, :update_value => "Jim Lynn,Fred Sled,Jan Man"

    response.should be_success
    response.body.should == "Jim Lynn,Fred Sled,Jan Man"

    associates = Room.find(room.id).associates_as_csv
    associates.should_not == original_associates
    associates.should == "Jim Lynn,Jan Man,Fred Sled"
  end

end
