# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150313052521) do

  create_table "commands", force: true do |t|
    t.integer  "user_id"
    t.integer  "kind"
    t.integer  "target"
    t.integer  "x"
    t.integer  "y"
    t.integer  "arg"
    t.integer  "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", force: true do |t|
    t.integer  "turn"
    t.string   "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lands", force: true do |t|
    t.integer  "user_id"
    t.string   "prize"
    t.integer  "absent"
    t.string   "comment"
    t.integer  "money"
    t.integer  "food"
    t.integer  "people"
    t.integer  "area"
    t.integer  "farm"
    t.integer  "factory"
    t.integer  "mountain"
    t.integer  "score"
    t.text     "land"
    t.text     "land_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lands", ["user_id"], name: "index_lands_on_user_id"

  create_table "message_bords", force: true do |t|
    t.integer  "land_id"
    t.string   "name"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
