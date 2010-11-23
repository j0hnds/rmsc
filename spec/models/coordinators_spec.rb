require 'spec_helper'

describe Coordinator do

  before(:each) do
    @coordinator = Coordinator.new
  end

  it "should allow a first, last name email address and phone number" do
    @coordinator.first_name = 'Diane'
    @coordinator.last_name = 'Sieh'
    @coordinator.email = 'dmsieh@comcast.net'
    @coordinator.phone = '303-471-2865'

    @coordinator.valid?.should be true
    @coordinator.save.should be true
  end

  it "must require that all fields be set" do
    @coordinator.valid?.should be false
    @coordinator.errors[:first_name].blank?.should be false
    @coordinator.errors[:last_name].blank?.should be false
    @coordinator.errors[:email].blank?.should be false
    @coordinator.errors[:phone].blank?.should be false
  end

  it "must not allow the first name to be longer than 20 characters" do
    @coordinator.first_name = '012345678901234567890' # 21 characters
    @coordinator.valid?.should be false
    @coordinator.errors[:first_name].blank?.should be false
  end

  it "must not allow the last name to be longer than 20 characters" do
    @coordinator.last_name = '012345678901234567890' # 21 characters
    @coordinator.valid?.should be false
    @coordinator.errors[:last_name].blank?.should be false
  end

  it "must not allow the email address to be longer than 255 characters" do
    @coordinator.email = "first.last@domain.com"
    @coordinator.valid?.should be false
    @coordinator.errors[:email].blank?.should be true

    @coordinator.email = "first.last@domain.com0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234"
    @coordinator.valid?.should be false
    @coordinator.errors[:email].blank?.should be false
  end

  it "must ensure that a specified phone number is valid" do
    @coordinator.phone = '303-333-3333'
    @coordinator.valid?.should be false
    @coordinator.errors[:phone].blank?.should be true

    @coordinator.phone = '303 333 3333'
    @coordinator.valid?.should be false
    @coordinator.errors[:phone].blank?.should be true

    @coordinator.phone = '(303) 333-3333'
    @coordinator.valid?.should be false
    @coordinator.errors[:phone].blank?.should be true

    @coordinator.phone = '(303) 333-33'
    @coordinator.valid?.should be false
    @coordinator.errors[:phone].blank?.should be false
  end

  it "must ensure that a specified email address is valid" do
    @coordinator.email = "first.last@domain.com"
    @coordinator.valid?.should be false
    @coordinator.errors[:email].blank?.should be true

    @coordinator.email = "first+last0123@123domain.com"
    @coordinator.valid?.should be false
    @coordinator.errors[:email].blank?.should be true
    
    @coordinator.email = "first+last0123123domaincom"
    @coordinator.valid?.should be false
    @coordinator.errors[:email].blank?.should be false
  end

end
