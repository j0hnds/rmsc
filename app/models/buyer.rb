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
  scope :not_in_show, lambda { | show | { :conditions => [ "id not in (select buyer_id from attendances where show_id = ?)", show.id ]}}
  scope :master_list, joins(:store).order('`stores`.name ASC, `buyers`.last_name, `buyers`.first_name')

  # The page size for mislav will paginate.
  @@per_page = 30

end
