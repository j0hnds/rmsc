class Coordinator < ActiveRecord::Base
  include RegularExpressions

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

  self.per_page = 5

  scope :ordered_by_name, order("coordinators.last_name ASC, coordinators.first_name ASC")
end
