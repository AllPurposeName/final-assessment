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

ActiveRecord::Schema.define(version: 20150624131313) do

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.boolean  "preferred",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "pairings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pair_id"
    t.boolean  "paired_before", default: false
    t.boolean  "interested",    default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "pairings", ["pair_id"], name: "index_pairings_on_pair_id"
  add_index "pairings", ["user_id"], name: "index_pairings_on_user_id"

  create_table "pairs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_languages", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "language_id"
  end

  add_index "user_languages", ["language_id"], name: "index_user_languages_on_language_id"
  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id"

  create_table "users", force: :cascade do |t|
    t.text     "description"
    t.string   "name"
    t.string   "avatar_url"
    t.string   "html_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
