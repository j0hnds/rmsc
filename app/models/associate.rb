class Associate < ActiveRecord::Base
  belongs_to :room

  validates :room_id, :presence => true
  validates :first_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }
  validates :last_name, :presence => true, :length => { :minimum => 1, :maximum => 40 }

  scope :ordered_by_name, order('last_name ASC, first_name ASC')

  def self.create_from_name(name)
    return nil if name.blank?
    name_list = name.split(' ').collect { | name | name.strip }
    return nil if name_list.length != 2
    Associate.new(:first_name => name_list.first, :last_name => name_list.last)
  end
end