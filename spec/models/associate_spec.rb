require "spec_helper"

describe Associate do

  it "should should construct a new associate given a name to split" do
    a = Associate.create_from_name("Jim   Henson")
    a.should_not be_nil
    a.room_id = 1
    a.first_name.should == 'Jim'
    a.last_name.should == 'Henson'
    a.valid?.should be_true
  end

  it "should not construct a new associate if the name is nil" do
    a = Associate.create_from_name(nil)
    a.should be_nil
  end

  it "should not construct a new associate if the name is blank" do
    a = Associate.create_from_name(' ')
    a.should be_nil
  end

  it "should not construct a new associate if only a single name is provided" do
    a = Associate.create_from_name(' Jim ')
    a.should be_nil
  end
end