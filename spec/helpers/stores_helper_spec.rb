require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the StoresHelper. For example:
#
# describe StoresHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe StoresHelper do

  it "should format a store address" do
    store = Factory.build(:store)
    helper.format_store_address(store).should == "123 Main<br>Aberdeen, CT 90111"
  end
end
