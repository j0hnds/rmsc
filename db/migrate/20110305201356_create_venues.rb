class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name, :limit => 40
      t.string :address_1, :limit => 60
      t.string :address_2, :limit => 60
      t.string :city, :limit => 60
      t.string :state, :limit => 2
      t.string :postal_code, :limit => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
