class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string :name, :limit => 40
      t.date :start_date
      t.date :end_date
      t.date :next_start_date
      t.date :next_end_date
      t.integer :coordinator_id
      t.integer :venue_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
