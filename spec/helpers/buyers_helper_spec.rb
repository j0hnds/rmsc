require 'spec_helper'

describe BuyersHelper do

  it "should format a buyer's name" do
    buyer = Factory.build(:buyer, :first_name => 'Joe', :last_name => 'Buyer')
    helper.format_buyer_name(buyer).should == "Buyer, Joe"
  end

  it "should format a set of stores as a select box option array" do
    store1 = Factory.create(:store, 
                           :name => 'Store1',
                           :address => '123 Main Street',
                           :city => 'Atlanta',
                           :state => 'GA',
                           :postal_code => '90118')
    store2 = Factory.create(:store, 
                           :name => 'Store2',
                           :address => '234 Main Street',
                           :city => 'Atlanta',
                           :state => 'GA',
                           :postal_code => '90118')

    options = helper.store_options([ store1, store2 ])
    options.should_not be_nil
    options.should_not be_empty
    options.should == [ [ 'Store1 - 123 Main Street, Atlanta', store1.id ],
                        [ 'Store2 - 234 Main Street, Atlanta', store2.id ] ]
                        
  end

end
