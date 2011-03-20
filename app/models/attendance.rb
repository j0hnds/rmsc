class Attendance < ActiveRecord::Base

  belongs_to :show
  belongs_to :buyer

  validates :show_id, :presence => true
  validates :buyer_id, :presence => true

  scope :for_show, lambda { | show | { :conditions => [ "show_id = ?", show.id ] } }

end