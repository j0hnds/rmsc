require 'spec_helper'

describe Store do

  it "should allow a store to be created with valid information" do
    store = Factory.build(:store)
    store.valid?.should be_true
  end

end
