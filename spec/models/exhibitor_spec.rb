require 'spec_helper'

describe Exhibitor do

  it "should allow an exhibitor to created with all valid data" do
    ex = Factory.build(:exhibitor)

    ex.valid?.should be_true
  end

  it "should restrict the first name to 40 characters" do
    ex = Factory.build(:exhibitor, :first_name => "a" * 41)
    ex.valid?.should be_false
    ex.errors[:first_name].blank?.should be_false
  end

  it "should restrict the last name to 40 characters" do
    ex = Factory.build(:exhibitor, :last_name => "a" * 41)
    ex.valid?.should be_false
    ex.errors[:last_name].blank?.should be_false
  end

  it "should restrict the address to 60 characters" do
    ex = Factory.build(:exhibitor, :address => "a" * 61)
    ex.valid?.should be_false
    ex.errors[:address].blank?.should be_false
  end

  it "should restrict the city to 60 characters" do
    ex = Factory.build(:exhibitor, :city => "a" * 61)
    ex.valid?.should be_false
    ex.errors[:city].blank?.should be_false
  end

  it "should restrict the state to 2 characters" do
    ex = Factory.build(:exhibitor, :state => "a" * 3)
    ex.valid?.should be_false
    ex.errors[:state].blank?.should be_false
  end

  it "should restrict the postal code to a correct pattern" do
    ex = Factory.build(:exhibitor, :postal_code => "abcde")

    ex.valid?.should be_false
    ex.errors[:postal_code].blank?.should be_false

    ex.postal_code = '00000-'
    ex.valid?.should be_false
    ex.errors[:postal_code].blank?.should be_false

    ex.postal_code = '00000-abcd'
    ex.valid?.should be_false
    ex.errors[:postal_code].blank?.should be_false

  end

  it "should restrict a phone number to a valid pattern" do
    ex = Factory.build(:exhibitor, :phone => "abc-000-0000")

    ex.valid?.should be_false
    ex.errors[:phone].blank?.should be_false
  end

  it "should restrict a fax number to a valid pattern" do
    ex = Factory.build(:exhibitor, :fax => "abc-000-0000")

    ex.valid?.should be_false
    ex.errors[:fax].blank?.should be_false
  end

  it "should restrict a cell number to a valid pattern" do
    ex = Factory.build(:exhibitor, :cell => "abc-000-0000")

    ex.valid?.should be_false
    ex.errors[:cell].blank?.should be_false
  end

  it "should restrict an email to a valid pattern" do
    ex = Factory.build(:exhibitor, :email => "harry.potter")

    ex.valid?.should be_false
    ex.errors[:email].blank?.should be_false
  end

end
