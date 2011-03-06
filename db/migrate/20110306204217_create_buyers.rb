class CreateBuyers < ActiveRecord::Migration
  def self.up
    create_table :buyers do |t|
      t.string :first_name, :limit => 40
      t.string :last_name, :limit => 40
      t.string :phone, :limit => 12
      t.string :email, :limit => 80
      t.integer :store_id

      t.timestamps
    end
  end

  def self.down
    drop_table :buyers
  end
end
