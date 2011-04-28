require 'spec_helper'

describe ShowHelper do

  it "should format the coordinator options" do
    c1 = Factory.create(:coordinator, 
                        :first_name => 'One',
                        :last_name => 'Coordinator')
    c2 = Factory.create(:coordinator, 
                        :first_name => 'Two',
                        :last_name => 'Coordinator')

    options = helper.coordinator_options([ c1, c2 ])
    options.should_not be_nil
    options.should_not be_empty
    options.should == [ [ 'Coordinator, One', c1.id ],
                        [ 'Coordinator, Two', c2.id ] ]

  end

  it "should format the venue options" do
    v1 = Factory.create(:venue,
                        :name => 'Venue1',
                        :address_1 => '123 Main Street',
                        :city => 'Atlanta',
                        :state => 'GA',
                        :postal_code => '90118')
    v2 = Factory.create(:venue,
                        :name => 'Venue2',
                        :address_1 => '234 Main Street',
                        :city => 'Atlanta',
                        :state => 'GA',
                        :postal_code => '90118')

    options = helper.venue_options([ v1, v2 ])
    options.should_not be_nil
    options.should_not be_empty
    options.should == [ [ 'Venue1 - 123 Main Street, Atlanta', v1.id ],
                        [ 'Venue2 - 234 Main Street, Atlanta', v2.id ] ]
  end

  it "should format the date range" do
    start_date = Date.new(2011, 4, 16)
    end_date = Date.new(2011, 4, 17)

    date_range = helper.format_date_range(start_date, end_date)
    date_range.should == '2011-04-16 -- 2011-04-17'
  end

  it "should format a set of show options" do
    v = Factory.create(:venue)
    c = Factory.create(:coordinator)
    s1 = Factory.create(:show, :venue => v, :coordinator => c, :name => 'Show1')
    s2 = Factory.create(:show, :venue => v, :coordinator => c, :name => 'Show2')

    options = helper.show_options([ s1, s2 ])
    options.should_not be_nil
    options.should_not be_empty
    options.should == [ [ 'Show1', s1.id ],
                        [ 'Show2', s2.id ] ]
  end

end
