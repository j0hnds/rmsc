class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name, :limit => 40
      t.string :address, :limit => 60
      t.string :city, :limit => 60
      t.string :state, :limit => 2
      t.string :postal_code, :limit => 10
      t.string :phone, :limit => 12
      t.string :fax, :limit => 12
      t.string :email, :limit => 80

      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
