require 'spec_helper'

describe AttendancesHelper do

  it "should format buyer options" do
    store = Factory.create(:store)
    buyer1 = Factory.create(:buyer, :store => store, :first_name => "Buyer", :last_name => "One")
    buyer2 = Factory.create(:buyer, :store => store, :first_name => "Buyer", :last_name => "Two")

    options = helper.buyer_options([buyer1, buyer2])
    options.should_not be_nil
    options.size.should == 2
    options.first.should == [ 'One, Buyer', buyer1.id ]
    options.second.should == [ 'Two, Buyer', buyer2.id ]

  end

end
