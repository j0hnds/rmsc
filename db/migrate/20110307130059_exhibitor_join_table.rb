class ExhibitorJoinTable < ActiveRecord::Migration
  def self.up

    create_table :registrations do | t |
      t.integer :show_id, :null => false
      t.integer :exhibitor_id, :null => false
    end

    create_table :rooms do |t|
      t.integer :registration_id, :null => false
      t.string :room
    end

    create_table :associates do |t|
      t.integer :room_id, :null => false
      t.string :first_name, :limit => 40
      t.string :last_name, :limit => 40
    end

    create_table :lines do |t|
      t.integer :room_id, :null => false
      t.integer :order, :null => false
      t.string :line, :null => false, :limit => 80
    end

  end

  def self.down
    drop_table :lines
    drop_table :associates
    drop_table :rooms
    drop_table :registrations
  end
end
