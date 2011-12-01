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

ActiveRecord::Schema.define(:version => 20111201081432) do

  create_table "admins", :force => true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email",                               :null => false
    t.string   "vinsol_id"
  end

  add_index "admins", ["authentication_token"], :name => "index_admins_on_authentication_token", :unique => true

  create_table "questions", :force => true do |t|
    t.text     "body",        :null => false
    t.integer  "level",       :null => false
    t.integer  "category_id", :null => false
    t.integer  "admin_id",    :null => false
    t.string   "type",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
