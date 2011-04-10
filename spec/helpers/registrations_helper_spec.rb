require 'spec_helper'

describe RegistrationsHelper do

  it "should format exhibitor options" do
    ex1 = Factory.create(:exhibitor, :first_name => 'Exhibitor', :last_name => 'One')
    ex2 = Factory.create(:exhibitor, :first_name => 'Exhibitor', :last_name => 'Two')

    options = helper.exhibitor_options([ ex1, ex2 ])

    options.should_not be_nil
    options.size.should == 2
    options.first.should == [ 'One, Exhibitor', ex1.id ]
    options.second.should == [ 'Two, Exhibitor', ex2.id ]
  end

end
