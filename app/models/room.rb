class Room < ActiveRecord::Base

  belongs_to :registration
  has_many :associates
  has_many :lines

  validates :registration_id, :presence => true

  scope :ordered_by_room, order('room ASC')

  def assign_lines_from_csv(lines_csv)
    if !lines_csv.blank?
      line_list = lines_csv.split(/,/).collect { | line | line.strip }
      line_list.each_with_index do | line, idx |
        self.lines << Line.new(:line => line, :order => idx)
      end
    end
  end

  def assign_associates_from_csv(associates_csv)
    if !associates_csv.blank?
      associate_list = associates_csv.split(/,/).collect { | associate | associate.strip }
      associate_list.each do | associate_name |
        self.associates << Associate.create_from_name(associate_name)
      end
    end
  end

  def assign_lines_from_other_room(room)
    # For each line assigned to the room
    room.lines.each do | line |
      self.lines << Line.new(:order => line.order, :line => line.line)
    end
  end

  def assign_associates_from_other_room(room)
      # For each associate assigned to the room
      room.associates.each do | associate |
        self.associates << Associate.new(:first_name => associate.first_name, :last_name => associate.last_name)
      end
  end

end
