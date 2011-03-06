require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ExhibitorsHelper. For example:
#
# describe ExhibitorsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ExhibitorsHelper do

  before(:each) do
    @exhibitor = Factory.create(:exhibitor)
  end

  it "knows how to correctly format an exhibitor name" do
    helper.format_exhibitor_name(@exhibitor).should == "Exhibitor, Joe"
  end
end
