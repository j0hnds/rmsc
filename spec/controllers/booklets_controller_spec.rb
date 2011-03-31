require 'spec_helper'

describe BookletsController do

  before(:each) do
    @venue = Factory.create(:venue)
    @coordinator = Factory.create(:coordinator)
    @show = Factory.create(:show, :venue => @venue, :coordinator => @coordinator)

    # Create two exhibitors to register with the show
    @exhibitor1 = Factory.create(:exhibitor, :first_name => 'John', :last_name => 'Smith')
    @exhibitor2 = Factory.create(:exhibitor, :first_name => 'Sam', :last_name => 'Hagar')

    # Register each of the exhibitors with the show
    registration = @show.register_exhibitor @exhibitor1, "Line 2, Line 1"
    registration.rooms.first.update_attribute(:room, '1001')

    registration = @show.register_exhibitor @exhibitor2, "Line 4, Line 3, Line 2"
    registration.rooms.first.update_attribute(:room, '2002')
  end

  it "should provide a set of all data needed for the booklet" do
    get :index

    exhibitor_count = assigns[:show_exhibitor_count]
    exhibitor_count.should_not be_nil
    exhibitor_count.should == 2

    line_count = assigns[:show_line_count]
    line_count.should_not be_nil
    line_count.should == 4

    exhibitors = assigns[:exhibitors]
    exhibitors.should_not be_nil
    exhibitors.size.should == 2

    exhibitor_lines = assigns[:exhibitor_lines]
    exhibitor_lines.should_not be_nil
    exhibitor_lines.size.should == 2
    exhibitor_lines.should have_key(@exhibitor1.id)
    exhibitor_lines.should have_key(@exhibitor2.id)

    lines = exhibitor_lines[@exhibitor1.id]
    lines.should_not be_nil
    lines.size.should == 2
    lines.should == [ 'Line 2', 'Line 1' ]

    lines = exhibitor_lines[@exhibitor2.id]
    lines.should_not be_nil
    lines.size.should == 3
    lines.should == [ 'Line 4', 'Line 3', 'Line 2' ]

    exhibitor_rooms = assigns[:exhibitor_rooms]
    exhibitor_rooms.should_not be_nil
    exhibitor_rooms.size.should == 2
    exhibitor_rooms.should have_key(@exhibitor1.id)
    exhibitor_rooms.should have_key(@exhibitor2.id)
    
    rooms = exhibitor_rooms[@exhibitor1.id]
    rooms.should_not be_nil
    rooms.size.should == 1
    rooms.collect(&:room).should == [ '1001' ]

    rooms = exhibitor_rooms[@exhibitor2.id]
    rooms.should_not be_nil
    rooms.size.should == 1
    rooms.collect(&:room).should == [ '2002' ]

    show_lines = assigns[:show_lines]
    show_lines.should_not be_nil

    show_lines.size.should == 5
    show_lines[0].should == [ 'Line 1', '1001', 'John Smith' ]
    show_lines[1].should == [ 'Line 2', '1001', 'John Smith' ]
    show_lines[2].should == [ 'Line 2', '2002', 'Sam Hagar' ]
    show_lines[3].should == [ 'Line 3', '2002', 'Sam Hagar' ]
    show_lines[4].should == [ 'Line 4', '2002', 'Sam Hagar' ]
  end

end
