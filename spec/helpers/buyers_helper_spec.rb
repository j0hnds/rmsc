require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BuyersHelper. For example:
#
# describe BuyersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe BuyersHelper do

  it "should format a buyer's name" do
    buyer = Factory.build(:buyer)
    helper.format_buyer_name(buyer).should == "Buyer, Joe"
  end
end
