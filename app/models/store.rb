class Store < ActiveRecord::Base
  include RegularExpressions

  validates :name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :address, :length => { :minimum => 1, :maximum => 60 }, :allow_blank => true, :allow_nil => true
  validates :city, :length => { :minimum => 1, :maximum => 60 }, :allow_blank => true, :allow_nil => true
  validates :state, :length => { :minimum => 1, :maximum => 2 }, :allow_blank => true, :allow_nil => true
  validates :postal_code, :length => { :minimum => 1, :maximum => 10 }, :format => RePostalCode, :allow_blank => true, :allow_nil => true
  validates :phone, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :fax, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :email, :length => { :maximum => 80 }, :format => ReEmail, :allow_blank => true, :allow_nil => true

  scope :ordered_by_name, order("stores.name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "name LIKE ?", "%#{search}%" ]}}

end
