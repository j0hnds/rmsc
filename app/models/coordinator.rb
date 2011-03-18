class Coordinator < ActiveRecord::Base
  include RegularExpressions

  has_many :shows

  validates :first_name, :presence => true,
                         :length => { :minimum => 1, :maximum => 20 }

  validates :last_name, :presence => true,
                        :length => { :minimum => 1, :maximum => 20 }

  validates :email, :presence => true,
                    :length => { :minimum => 1, :maximum => 255 },
                    :format => { :with => ReEmail }

  validates :phone, :presence => true,
                    :length => { :minimum => 1, :maximum => 14 },
                    :format => { :with => RePhone }

  scope :ordered_by_name, order("coordinators.last_name ASC, coordinators.first_name ASC")
  scope :filtered, lambda { | search | { :conditions => [ "first_name LIKE :name_match OR last_name LIKE :name_match", :name_match => "%#{search}%" ]}}

  @@per_page = 30

end
