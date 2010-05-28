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

ActiveRecord::Schema.define(:version => 20100225192835) do

  create_table "ad_computers", :force => true do |t|
    t.string   "remote_id",         :null => false
    t.integer  "content_server_id", :null => false
    t.string   "name",              :null => false
    t.string   "user",              :null => false
    t.date     "last_cached",       :null => false
    t.date     "last_accessed",     :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "applied_configurations", :force => true do |t|
    t.integer  "configuration_id", :null => false
    t.integer  "computer_id",      :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "position",         :null => false
  end

  create_table "applied_packages", :force => true do |t|
    t.integer  "package_id",       :null => false
    t.integer  "configuration_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "position",         :null => false
  end

  create_table "computers", :force => true do |t|
    t.string   "mac_address", :null => false
    t.string   "name",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "platform",    :null => false
    t.integer  "owner_id",    :null => false
  end

  create_table "configurations", :force => true do |t|
    t.string   "name",             :null => false
    t.string   "notes",            :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "host_computer_id", :null => false
    t.integer  "owner_id",         :null => false
  end

  create_table "content_servers", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "address",     :null => false
    t.string   "username",    :null => false
    t.string   "password",    :null => false
    t.string   "server_type", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "package_tests", :force => true do |t|
    t.integer  "package_id",     :null => false
    t.string   "name",           :null => false
    t.string   "description",    :null => false
    t.string   "rule_type",      :null => false
    t.string   "rule_parameter", :null => false
    t.string   "success_value",  :null => false
    t.string   "position",       :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "packages", :force => true do |t|
    t.string   "name",             :null => false
    t.boolean  "licensed",         :null => false
    t.string   "source_path",      :null => false
    t.string   "executable",       :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "deployment_stage", :null => false
    t.string   "platform",         :null => false
    t.integer  "owner_id",         :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "site",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",             :null => false
    t.string   "email",             :null => false
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "persistence_token", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
