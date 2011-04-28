require 'spec_helper'

describe CoordinatorHelper do

  it "should format a coordinator name" do
    coord = Factory.build(:coordinator, 
                          :first_name => 'Joe', 
                          :last_name => 'Coordinator')

    cname = helper.format_coordinator_name(coord)

    cname.should == 'Coordinator, Joe'
  end

end
