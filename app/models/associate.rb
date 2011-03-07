class Associate < ActiveRecord::Base
  belongs_to :room

  validates :room_id, :presence => true
  validates :first_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :last_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }

  scope :ordered_by_name, order('last_name ASC, first_name ASC')
end