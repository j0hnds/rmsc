class Registration < ActiveRecord::Base

  belongs_to :exhibitor
  belongs_to :show
  has_many :rooms
  has_many :associates, :through => :rooms
  has_many :lines, :through => :rooms

  validates :show_id, :presence => true
  validates :exhibitor_id, :presence => true

  scope :for_show, lambda { | show_id | { :conditions => [ "show_id = ?", show_id ]}}

end