class Venue < ActiveRecord::Base

  validates :name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :address_1, :presence => true, :length => { :minimum => 1, :maximum => 60 }
  validates :address_2, :length => { :maximum => 60 }
  validates :city, :presence => true, :length => { :minimum => 1, :maximum => 60 }
  validates :state, :presence => true, :length => { :minimum => 1, :maximum => 2 }
  validates :postal_code, :presence => true, :length => { :minimum => 1, :maximum => 10 }, :format => /\A\d{5}(-\d{1,4})?\z/

  scope :ordered_by_name, order("venues.name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "name LIKE ?", "%#{search}%" ]}}
end
