class CreateCoordinators < ActiveRecord::Migration
  def self.up
    create_table :coordinators do |t|
      t.string :first_name, :limit => 20, :null => false
      t.string :last_name, :limit => 20, :null => false
      t.string :email, :limit => 255, :null => false
      t.string :phone, :limit => 14, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coordinators
  end
end
