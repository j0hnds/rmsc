class Coordinator < ActiveRecord::Base
  include RegularExpressions

  validates_presence_of(:first_name, :last_name, :email, :phone)
  validates_length_of(:first_name, 
                      :maximum => 20, 
                      :allow_nil => true, 
                      :allow_blank => true)
  validates_length_of(:last_name, 
                      :maximum => 20, 
                      :allow_nil => true, 
                      :allow_blank => true)
  validates_length_of(:email,
                      :maximum => 255,
                      :allow_nil => true,
                      :allow_blank => true)
  validates_format_of(:phone,
                      :with => RePhone,
                      :allow_nil => true,
                      :allow_blank => true)
  validates_format_of(:email,
                      :with => ReEmail,
                      :allow_nil => true,
                      :allow_blank => true)

  scope :ordered_by_name, order("coordinators.last_name ASC, coordinators.first_name ASC")
end
