class BuyerJoinTable < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :show_id, :null => false
      t.integer :buyer_id, :null => false
    end
  end

  def self.down
    drop_table :attendances
  end
end
