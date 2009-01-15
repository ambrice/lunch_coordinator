# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090110182924) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "owner_id"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_user_histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "selections_since_picked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_user_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "role",                                     :default => "user"
    t.integer  "group_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
