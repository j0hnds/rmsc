class AddVenuePhones < ActiveRecord::Migration
  def self.up
    add_column :venues, :phone, :string, :limit => 12
    add_column :venues, :fax, :string, :limit => 12
    add_column :venues, :reservation, :string, :limit => 12
  end

  def self.down
    remove_column :venues, :phone
    remove_column :venues, :fax
    remove_column :venues, :reservation
  end
end
