require 'spec_helper'

describe Buyer do

  before(:each) do
    @store = FactoryGirl.create(:store)
  end

  it "should allow a buyer to be created with valid data" do
    buyer = FactoryGirl.build(:buyer, :store => @store)
    buyer.valid?.should be_true
  end

end
