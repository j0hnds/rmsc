require 'spec_helper'

describe BookletsHelper do

  it "should correctly format a coordinator's name" do
    coordinator = Coordinator.new(:first_name => 'Jim', :last_name => 'Jones')
    helper.coordinator_name(coordinator).should == 'Jim Jones'
  end

  it "should coorectly format an exhibitor's name" do
    exhibitor = Exhibitor.new(:first_name => 'Jim', :last_name => 'Jones')
    helper.exhibitor_name(exhibitor).should == 'Jim Jones'
  end

  it "should correctly format a singular room when an exhibitor has only one room" do
    rooms = [ Room.new(:room => '1001') ]
    helper.exhibitor_rooms(rooms).should == 'Room: #1001'
  end

  it "should correctly format a plural room when an exhibitor has more than one room" do
    rooms = [ Room.new(:room => '1001'), Room.new(:room => '2001') ]
    helper.exhibitor_rooms(rooms).should == 'Rooms: #1001, #2001'
  end

  it "should correctly format an exhibitor's address" do
    ex = Exhibitor.new(:address => '123 Main', :city => 'Taos', :state => 'NM', :postal_code => '80111')
    helper.exhibitor_address(ex).should == "123 Main\nTaos, NM  80111"
  end

  it "should correctly format a venue's address" do
    ve = Venue.new(:address_1 => '123 Main', :city => 'Taos', :state => 'NM', :postal_code => '80111')
    helper.venue_address(ve).should == "123 Main\nTaos, NM  80111"
  end
end
