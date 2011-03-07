class Buyer < ActiveRecord::Base
  include RegularExpressions

  belongs_to :store
  has_many :attendances
  has_many :shows, :through => :attendances

  validates :first_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :last_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :phone, :length => { :maximum => 12 }, :format => RePhone, :allow_blank => true, :allow_nil => true
  validates :email, :length => { :maximum => 80 }, :format => ReEmail, :allow_blank => true, :allow_nil => true
  validates :store_id, :presence => true

  scope :ordered_by_name, order("buyers.last_name ASC, buyers.first_name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "first_name LIKE :name OR last_name LIKE :name", :name => "%#{search}%" ]}}
end