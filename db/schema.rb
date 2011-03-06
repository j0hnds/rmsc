# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110306212318) do

  create_table "buyers", :force => true do |t|
    t.string   "first_name", :limit => 40
    t.string   "last_name",  :limit => 40
    t.string   "phone",      :limit => 12
    t.string   "email",      :limit => 80
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinators", :force => true do |t|
    t.string   "first_name", :limit => 20, :null => false
    t.string   "last_name",  :limit => 20, :null => false
    t.string   "email",                    :null => false
    t.string   "phone",      :limit => 14, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibitors", :force => true do |t|
    t.string   "first_name",  :limit => 40
    t.string   "last_name",   :limit => 40
    t.string   "address",     :limit => 60
    t.string   "city",        :limit => 60
    t.string   "state",       :limit => 2
    t.string   "postal_code", :limit => 10
    t.string   "phone",       :limit => 12
    t.string   "fax",         :limit => 12
    t.string   "cell",        :limit => 12
    t.string   "email",       :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", :force => true do |t|
    t.string   "name",            :limit => 40
    t.date     "start_date"
    t.date     "end_date"
    t.date     "next_start_date"
    t.date     "next_end_date"
    t.integer  "coordinator_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "name",        :limit => 40
    t.string   "address",     :limit => 60
    t.string   "city",        :limit => 60
    t.string   "state",       :limit => 2
    t.string   "postal_code", :limit => 10
    t.string   "phone",       :limit => 12
    t.string   "fax",         :limit => 12
    t.string   "email",       :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", :force => true do |t|
    t.string   "name",        :limit => 40
    t.string   "address_1",   :limit => 60
    t.string   "address_2",   :limit => 60
    t.string   "city",        :limit => 60
    t.string   "state",       :limit => 2
    t.string   "postal_code", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",       :limit => 12
    t.string   "fax",         :limit => 12
    t.string   "reservation", :limit => 12
  end

end
