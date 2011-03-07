class Line < ActiveRecord::Base

  belongs_to :room

  validates :room_id, :presence => true
  validates :order, :presence => true
  validates :line, :presence => true, :length => { :minimum => 1, :maximum => 80 }

  scope :ordered, order('order ASC')
end