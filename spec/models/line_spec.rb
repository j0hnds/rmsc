require 'spec_helper'

describe Line do

  LINES_CSV = "line 1, line 2, line 3, line 4"

  before(:each) do
    @room = Factory.create(:room, :registration_id => 1)
  end

  it "allow a line to be moved up in ordering" do
    @room.assign_lines_from_csv(LINES_CSV)

    line = @room.lines.first

    line.move_up

    lines = @room.lines.ordered
    lines.size.should be 4
    lines[0].line.should == 'line 1'
    lines[1].line.should == 'line 2'
    lines[2].line.should == 'line 3'
    lines[3].line.should == 'line 4'
  end

  it "allow a line to be moved up in ordering from last" do
    @room.assign_lines_from_csv(LINES_CSV)

    line = @room.lines.last

    line.move_up

    lines = @room.lines.ordered
    lines.size.should be 4
    lines[0].line.should == 'line 1'
    lines[1].line.should == 'line 2'
    lines[2].line.should == 'line 4'
    lines[3].line.should == 'line 3'
  end

  it "allow a line to be moved down in ordering" do
    @room.assign_lines_from_csv(LINES_CSV)

    line = @room.lines.last

    line.move_down

    lines = @room.lines.ordered
    lines.size.should be 4
    lines[0].line.should == 'line 1'
    lines[1].line.should == 'line 2'
    lines[2].line.should == 'line 3'
    lines[3].line.should == 'line 4'
  end

  it "allow a line to be moved up in ordering from first" do
    @room.assign_lines_from_csv(LINES_CSV)

    line = @room.lines.first

    line.move_down

    lines = @room.lines.ordered
    lines.size.should be 4
    lines[0].line.should == 'line 2'
    lines[1].line.should == 'line 1'
    lines[2].line.should == 'line 3'
    lines[3].line.should == 'line 4'
  end

end
