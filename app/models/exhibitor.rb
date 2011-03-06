class Exhibitor < ActiveRecord::Base
  include RegularExpressions

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
end
