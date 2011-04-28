require 'spec_helper'

describe ExhibitorsHelper do

  before(:each) do
    @exhibitor = Factory.create(:exhibitor, 
                                :first_name => 'Joe', 
                                :last_name => 'Exhibitor',
                                :address => '123 Main Street',
                                :city => 'Atlanta',
                                :state => 'GA',
                                :postal_code => '90118')
  end

  it "knows how to correctly format an exhibitor name" do
    helper.format_exhibitor_name(@exhibitor).should == "Exhibitor, Joe"
  end

  it "knows how to format an exhibitor address" do
    helper.format_exhibitor_address(@exhibitor).should == '123 Main Street<br>Atlanta, GA 90118'
  end
end
