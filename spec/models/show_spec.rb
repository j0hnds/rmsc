require 'spec_helper'

describe Show do

  before(:each) do
    @venue = Factory.create(:venue)
    @coordinator = Factory.create(:coordinator)
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
    show = Factory.build(:show, :venue => @venue, :coordinator => @coordinator)
    show.valid?.should be_true
  end

  it "should not allow a name longer than 40 characters" do
    show = Factory.build(:show, :venue => @venue, :coordinator => @coordinator, :name => "a" * 41)
    show.valid?.should be_false
    show.errors[:name].empty?.should be_false
  end

end
