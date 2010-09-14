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

ActiveRecord::Schema.define(:version => 20100714145540) do
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
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "host_computer_id"
    t.integer  "owner_id"
    t.string   "platform"
  end

  create_table "install_validation_reactions", :force => true do |t|
    t.string   "command"
    t.string   "parameter"
    t.integer  "repetitions"
    t.integer  "install_validation_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "install_validations", :force => true do |t|
    t.integer  "package_id"
    t.string   "description"
    t.string   "rule_type"
    t.string   "rule_parameter"
    t.string   "success_value"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
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
