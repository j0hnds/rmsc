require 'spec_helper'

describe Show do

  before(:each) do
    @venue = FactoryGirl.create(:venue)
    @coordinator = FactoryGirl.create(:coordinator)
  end

  it "should determine the correct dates for the next show based on the specified date" do

    show = Show.new
    start_date, end_date = show.show_dates_after_date(Date.new(2011, 3, 11))

    start_date.should == Date.new(2011, 9, 10)
    end_date.should == Date.new(2011, 9, 11)

    start_date, end_date = show.show_dates_after_date(Date.new(2010, 9, 11))

    start_date.should == Date.new(2011, 3, 5)
    end_date.should == Date.new(2011, 3, 6)

  end

  it "should successfully create a show with all valid data" do
    show = FactoryGirl.build(:show, :venue => @venue, :coordinator => @coordinator)
    show.valid?.should be_true
  end

  it "should not allow a name longer than 40 characters" do
    show = FactoryGirl.build(:show, :venue => @venue, :coordinator => @coordinator, :name => "a" * 41)
    show.valid?.should be_false
    show.errors[:name].empty?.should be_false
  end

  it "should create a default room assignment with no lines and associates if no prior registration is available and no lines or associates have been specified" do
    # Create an exhibitor
    ex = FactoryGirl.create(:exhibitor) # No pre-existing registrations to other shows

    # Create a show to register the exhibitor with
    show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    # register the exhibitor with the show
    show.register_exhibitor(ex)

    registrations = ex.registrations
    registrations.should_not be_nil
    registrations.length.should be 1

    registration = registrations.first
    registration.should_not be_nil

    rooms = registration.rooms
    rooms.should_not be_nil
    rooms.size.should be 1

    room = rooms.first
    room.should_not be_nil
    room.room.should be_blank

    room.lines.should_not be_nil
    room.lines.should be_empty

    room.associates.should_not be_nil
    room.associates.should be_empty
  end

  it "should create a default room assignment with lines and associates if no prior registration is available and lines and associates have been specified" do
    # Create an exhibitor
    ex = FactoryGirl.create(:exhibitor) # No pre-existing registrations to other shows

    # Create a show to register the exhibitor with
    show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    # register the exhibitor with the show
    show.register_exhibitor(ex, " line 1 , line 2 ", " John Smith , Henrietta Johnson ")

    registrations = ex.registrations
    registrations.should_not be_nil
    registrations.length.should be 1

    registration = registrations.first
    registration.should_not be_nil

    rooms = registration.rooms
    rooms.should_not be_nil
    rooms.size.should be 1

    room = rooms.first
    room.should_not be_nil
    room.room.should be_blank

    room.lines.should_not be_nil
    room.lines.size.should be 2
    room.lines.first.line.should == 'line 1'
    room.lines.second.line.should == 'line 2'

    room.associates.should_not be_nil
    room.associates.size.should be 2
    room.associates.first.first_name.should == 'John'
    room.associates.first.last_name.should == 'Smith'
    room.associates.second.first_name.should == 'Henrietta'
    room.associates.second.last_name.should == 'Johnson'
  end

  it "should clone an exhibitor's previous registration information" do
    ex = FactoryGirl.create(:exhibitor) # No pre-existing registrations to other shows

    # Create a show to register the exhibitor with
    prior_show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    # register the exhibitor with the show. This will end up being the
    # prior registration
    prior_registration = prior_show.register_exhibitor(ex, " line 1 , line 2 ", " John Smith , Henrietta Johnson ")

    # Set the room number
    prior_registration.rooms.first.update_attributes(:room => '303')

    # Create the new show to which the exhibitor will be registered
    new_show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator, :name => 'New Show')

    # register the exhibitor with the new show.
    new_show.register_exhibitor(ex)

    registrations = ex.registrations
    registrations.should_not be_nil
    registrations.length.should be 2

    registration = registrations.second
    registration.should_not be_nil

    rooms = registration.rooms
    rooms.should_not be_nil
    rooms.size.should be 1

    room = rooms.first
    room.should_not be_nil
    room.room.should == '303'

    room.lines.should_not be_nil
    room.lines.size.should be 2
    room.lines.first.line.should == 'line 1'
    room.lines.second.line.should == 'line 2'

    room.associates.should_not be_nil
    room.associates.size.should be 2
    room.associates.first.first_name.should == 'John'
    room.associates.first.last_name.should == 'Smith'
    room.associates.second.first_name.should == 'Henrietta'
    room.associates.second.last_name.should == 'Johnson'
  end

  it "should clone an exhibitor's previous registration information with the lines and associates overridden" do
    ex = FactoryGirl.create(:exhibitor) # No pre-existing registrations to other shows

    # Create a show to register the exhibitor with
    prior_show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    # register the exhibitor with the show. This will end up being the
    # prior registration
    prior_registration = prior_show.register_exhibitor(ex, " line 1 , line 2 ", " John Smith , Henrietta Johnson ")

    # Set the room number
    prior_registration.rooms.first.update_attributes(:room => '303')

    # Create the new show to which the exhibitor will be registered
    new_show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator, :name => 'New Show')

    # register the exhibitor with the new show.
    new_show.register_exhibitor(ex, " line 3 , line 4, line 5", " Jim Jameson")

    registrations = ex.registrations
    registrations.should_not be_nil
    registrations.length.should be 2

    registration = registrations.second
    registration.should_not be_nil

    rooms = registration.rooms
    rooms.should_not be_nil
    rooms.size.should be 1

    room = rooms.first
    room.should_not be_nil
    room.room.should == '303'

    room.lines.should_not be_nil
    room.lines.size.should be 3
    room.lines.first.line.should == 'line 3'
    room.lines.second.line.should == 'line 4'
    room.lines.third.line.should == 'line 5'

    room.associates.should_not be_nil
    room.associates.size.should be 1
    room.associates.first.first_name.should == 'Jim'
    room.associates.first.last_name.should == 'Jameson'
  end

end
