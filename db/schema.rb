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

ActiveRecord::Schema.define(:version => 20090731142114) do

  create_table "ad_computers", :force => true do |t|
    t.string   "remote_id"
    t.integer  "content_server_id"
    t.string   "name"
    t.string   "user"
    t.date     "last_cached"
    t.date     "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applied_configurations", :force => true do |t|
    t.integer  "configuration_id"
    t.integer  "computer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "applied_packages", :force => true do |t|
    t.integer  "package_id"
    t.integer  "configuration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "computers", :force => true do |t|
    t.string   "mac_address"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_servers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "username"
    t.string   "password"
    t.string   "server_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_tests", :force => true do |t|
    t.integer  "package_id"
    t.string   "name"
    t.string   "description"
    t.string   "rule_type"
    t.string   "rule_parameter"
    t.string   "success_value"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.boolean  "licensed"
    t.string   "source_path"
    t.string   "executable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deployment_stage"
    t.string   "platform"
  end

end
