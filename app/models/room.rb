class Room < ActiveRecord::Base

  belongs_to :registration
  has_many :associates
  has_many :lines

  validates :registration_id, :presence => true

  scope :ordered_by_room, order('room ASC')

end