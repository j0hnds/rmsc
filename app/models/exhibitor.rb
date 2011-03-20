class Exhibitor < ActiveRecord::Base
  include RegularExpressions

  has_many :registrations
  has_many :shows, :through => :registrations
  has_many :rooms, :through => :registrations

  validates :first_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :last_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :address, :presence => true, :length => { :minimum => 1, :maximum => 60 }
  validates :city, :presence => true, :length => { :minimum => 1, :maximum => 60 }
  validates :state, :presence => true, :length => { :minimum => 1, :maximum => 2 }
  validates :postal_code, :presence => true, :length => { :minimum => 1, :maximum => 10 }, :format => RePostalCode
  validates :phone, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :fax, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :cell, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :email, :length => { :maximum => 80 }, :format => ReEmail, :allow_blank => true, :allow_nil => true

  scope :ordered_by_name, order("exhibitors.last_name ASC, exhibitors.first_name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "first_name LIKE :name_match OR last_name LIKE :name_match", :name_match => "%#{search}%" ]}}
  scope :not_in_show, lambda { | show | { :conditions => [ "id not in (select exhibitor_id from registrations where show_id = ?)", show.id ]}}

  @@per_page = 30

  def eligible_for_show_registration?(show)
    # So, the exhibitor is eligible if:
    #  * new exhibitor
    #  * show is not already associated
    self.new_record? || !self.shows.include?(show)
  end

  def registered_for_show?(show)
    self.persisted? && self.shows.include?(show)
  end

#  def register_for_show(show, lines, associates)
#    prior_registration = self.registrations.latest
#
#    # Create the registration
#    registration = Registration.create(:show => show, :exhibitor => self)
#
#    if prior_registration
#      # Loop through all the rooms in the prior registration
#      prior_registration.rooms.each do |room|
#        new_room = Room.new(:room => room.room)
#        registration.rooms << new_room
#        # For each line assigned to the room
#        room.lines do | line |
#          new_room.lines << Line.new(:order => line.order, :line => line.line)
#        end
#        # For each associate assigned to the room
#        room.associates do | associate |
#          new_room.associates << Associate.new(:first_name => associate.first_name, :last_name => associate.last_name)
#        end
#      end
#    else
#      room = Room.new
#      registration.rooms << room
#      if !lines.blank?
#        line_list = lines.split(/,/).collect { | line | line.strip }
#        line_list.each_with_index do | line, idx |
#          room.lines << Line.new(:line => line, :order => idx)
#        end
#      end
#      if !associates.blank?
#        associate_list = associates.split(/,/).collect { | associate | associate.strip }
#        associate_list.each do | associate_name |
#          room.associates << Associate.create(associate_name)
#        end
#      end
#    end
#  end

end
