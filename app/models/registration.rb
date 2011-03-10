class Registration < ActiveRecord::Base

  belongs_to :exhibitor
  belongs_to :show
  has_many :rooms
  has_many :associates, :through => :rooms
  has_many :lines, :through => :rooms

  validates :show_id, :presence => true
  validates :exhibitor_id, :presence => true

  scope :for_show, lambda { | show_id | { :conditions => [ "show_id = ?", show_id ]}}
  scope :latest, order('id DESC')

  def initialize_registration(lines, associates)
    # Determine if there were any prior registrations for the exhibitor
    registrations = self.exhibitor.registrations.reload.latest
    prior_registration = (registrations.size >= 2) ? registrations.second : nil

    if prior_registration
      initialize_with_prior_registration(prior_registration, lines, associates)
    else
      initialize_with_no_prior_registration(lines, associates)
    end
  end

  private

  def initialize_with_prior_registration(prior_registration, lines, associates)
    # Loop through all the rooms in the prior registration
    prior_registration.rooms.each do |room|
      new_room = Room.new(:room => room.room)
      self.rooms << new_room

      if lines.blank?
        new_room.assign_lines_from_other_room(room)
      else
        new_room.assign_lines_from_csv(lines)
      end

      if associates.blank?
        new_room.assign_associates_from_other_room(room)
      else
        new_room.assign_associates_from_csv(associates)
      end
    end
  end

  def initialize_with_no_prior_registration(lines, associates)
    room = Room.new
    self.rooms << room

    room.assign_lines_from_csv(lines)

    room.assign_associates_from_csv(associates)
  end

end
