require "spec_helper"

describe Attendance do

  before(:each) do
    @venue = FactoryGirl.create(:venue)
    @coordinator = FactoryGirl.create(:coordinator)
    @show = FactoryGirl.create(:show, :venue => @venue, :coordinator => @coordinator)

    @store = FactoryGirl.create(:store)
    @buyer = FactoryGirl.create(:buyer, :store => @store)
  end

  it "should tie a buyer to a show" do
    @show.buyers << @buyer

    attendances = Attendance.all
    attendances.should_not be_nil
    attendances.size.should be 1

    attendances.first.buyer_id.should == @buyer.id
    attendances.first.show_id.should == @show.id
  end

  it "should tie a show to a buyer" do
    @buyer.shows << @show

    attendances = Attendance.all
    attendances.should_not be_nil
    attendances.size.should be 1

    attendances.first.buyer_id.should == @buyer.id
    attendances.first.show_id.should == @show.id
  end
end
