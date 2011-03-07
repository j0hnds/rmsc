require "spec_helper"

describe Registration do

  before(:each) do
    @coordinator = Factory.create(:coordinator)
    @venue = Factory.create(:venue)
    @show = Factory.create(:show, :coordinator => @coordinator, :venue => @venue)
    @exhibitor = Factory.create(:exhibitor)
  end

  it "should tie an exhibitor to a show" do
    registration = Registration.new(:show => @show, :exhibitor => @exhibitor)
    registration.valid?.should be_true
    registration.save.should be_true

    e = registration.exhibitor
    e.should_not be_nil
    shows = e.shows
    shows.should_not be_nil
    shows.size.should be 1
    shows.first.should == @show

    s = registration.show
    s.should_not be_nil
    exhibitors = s.exhibitors
    exhibitors.should_not be_nil
    exhibitors.size.should be 1
    exhibitors.first.should == @exhibitor
  end

  it "should allow more than one room to an exhibitor" do
    registration = Registration.create(:show => @show, :exhibitor => @exhibitor)
    room1 = Room.new() # No room number
    room2 = Room.new(:room => '2301')
    registration.rooms << room1
    registration.rooms << room2
    registration.save.should be_true

    rooms = @exhibitor.rooms
    rooms.should_not be_nil
    rooms.size.should be 2
    rooms.first.should == room1
    rooms.last.should == room2

    rooms = @show.rooms
    rooms.should_not be_nil
    rooms.size.should be 2
    rooms.first.should == room1
    rooms.last.should == room2
  end

  it "should allow one or more associate to a room" do
    registration = Registration.create(:show => @show, :exhibitor => @exhibitor)
    room1 = Room.new() # No room number

    registration.rooms << room1

    registration.save.should be_true

    # add an associate to the room
    room1.associates << Associate.new(:first_name => 'Bob', :last_name => 'Assoc')
    room1.associates << Associate.new(:first_name => 'Tim', :last_name => 'Assoc')
    room1.save.should be_true

    room = @exhibitor.rooms.first
    room.should_not be_nil
    assocs = room.associates
    assocs.should_not be_nil
    assocs.size.should be 2
    assocs.first.first_name.should == 'Bob'
    assocs.last.first_name.should == 'Tim'
  end

  it "should allow one or more lines to a room" do
    registration = Registration.create(:show => @show, :exhibitor => @exhibitor)
    room1 = Room.new() # No room number

    registration.rooms << room1

    registration.save.should be_true

    # add lines to the room
    room1.lines << Line.new(:order => 1, :line => 'Line 1')
    room1.lines << Line.new(:order => 2, :line => 'Line 2')
    room1.save.should be_true

    room = @exhibitor.rooms.first
    room.should_not be_nil
    lines = room.lines
    lines.should_not be_nil
    lines.size.should be 2
    lines.first.line.should == 'Line 1'
    lines.last.line.should == 'Line 2'
  end

  it "should allow a specific show registration to be selected" do
    Registration.create(:show => Factory.create(:show, :coordinator => @coordinator, :venue => @venue), :exhibitor => @exhibitor)
    registration = Registration.create(:show => @show, :exhibitor => @exhibitor)
    room1 = Room.new(:room => '2201')

    registration.rooms << room1

    registration.save.should be_true

    registration = @exhibitor.registrations.for_show(@show.id)
    registration.should_not be_nil
    registration.first.rooms.should_not be nil
  end
end