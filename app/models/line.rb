class Line < ActiveRecord::Base

  belongs_to :room

  validates :room_id, :presence => true
  validates :order, :presence => true
  validates :line, :presence => true, :length => { :minimum => 1, :maximum => 80 }

  scope :ordered, order("`order` ASC")
  scope :for_show, lambda { | show | joins(:room => :registration).where('show_id = ?', show.id).order('`line` ASC') }
  scope :for_exhibitor, lambda { | show, exhibitor | joins(:room => :registration).where('show_id = ? AND exhibitor_id = ?', show.id, exhibitor.id).order('`order` ASC, `line` ASC' ) } 

  def move_up
    # Get the list of all lines for this room
    all_lines = self.room.lines.ordered
    
    # Find the index of this line within the list
    index = all_lines.index(self)
    raise "Didn't find the line within the set of lines for the room" unless index

    if index > 0
      line_to_move_up = all_lines[index]
      line_to_move_up.update_attribute(:order, line_to_move_up.order - 1)

      line_immediately_above = all_lines[index - 1]
      line_immediately_above.update_attribute(:order, line_immediately_above.order + 1)
    end
  end

  def move_down
    # Get the list of all lines for this room
    all_lines = self.room.lines.ordered

    # Find the index of this line within the list
    index = all_lines.index(self)
    raise "Didn't find the line within the set of lines for the room" unless index

    if index < (all_lines.size - 1)
      line_to_move_down = all_lines[index]
      line_to_move_down.update_attribute(:order, line_to_move_down.order + 1)

      line_immediately_below = all_lines[index + 1]
      line_immediately_below.update_attribute(:order, line_immediately_below.order - 1)
    end

  end

end
