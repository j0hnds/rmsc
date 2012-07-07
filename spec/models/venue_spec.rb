require 'spec_helper'

describe Venue do

  it "should accept all valid data" do
    venue = FactoryGirl.build(:venue)
    venue.valid?.should be_true
  end

  it "should not allow a name longer than 40 characters" do
    venue = FactoryGirl.build(:venue, :name => "a" * 41)
    venue.valid?.should be_false
    venue.errors[:name].size.should be 1
  end

  it "should not allow an address_1 longer than 60 characters" do
    venue = FactoryGirl.build(:venue, :address_1 => "a" * 61)
    venue.valid?.should be_false
    venue.errors[:address_1].size.should be 1
  end

  it "should not allow an address_2 longer than 60 characters" do
    venue = FactoryGirl.build(:venue, :address_2 => "a" * 61)
    venue.valid?.should be_false
    venue.errors[:address_2].size.should be 1
  end

  it "should not allow a city longer than 60 characters" do
    venue = FactoryGirl.build(:venue, :city => "a" * 61)
    venue.valid?.should be_false
    venue.errors[:city].size.should be 1
  end

  it "should not allow a state longer than 2 characters" do
    venue = FactoryGirl.build(:venue, :state => "a" * 3)
    venue.valid?.should be_false
    venue.errors[:state].size.should be 1
  end

  it "should not allow an improper postal code" do
    venue = FactoryGirl.build(:venue)

    venue.postal_code = 'abcde'
    venue.valid?.should be_false
    venue.errors[:postal_code].size.should be 1

    venue.postal_code = '01234-'
    venue.valid?.should be_false
    venue.errors[:postal_code].size.should be 1

    venue.postal_code = '01234-abcd'
    venue.valid?.should be_false
    venue.errors[:postal_code].size.should be 1

    venue.postal_code = '01234-01234'
    venue.valid?.should be_false
    venue.errors[:postal_code].size.should be 2

  end
end
