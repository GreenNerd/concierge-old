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

ActiveRecord::Schema.define(version: 20170119090959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.date     "appoint_at"
    t.integer  "business_category_id"
    t.string   "id_number"
    t.string   "phone_number"
    t.string   "queue_number"
    t.boolean  "expired",              default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["appoint_at"], name: "index_appointments_on_appoint_at", using: :btree
    t.index ["business_category_id"], name: "index_appointments_on_business_category_id", using: :btree
    t.index ["id_number"], name: "index_appointments_on_id_number", using: :btree
  end

  create_table "availabilities", force: :cascade do |t|
    t.boolean "available"
    t.string  "effective_date"
    t.index ["available"], name: "index_availabilities_on_available", using: :btree
    t.index ["effective_date"], name: "index_availabilities_on_effective_date", using: :btree
  end

  create_table "business_categories", force: :cascade do |t|
    t.string  "prefix"
    t.integer "number"
    t.string  "name"
    t.string  "queue_number"
  end

  create_table "business_counters", force: :cascade do |t|
    t.integer "business_category_id"
    t.integer "number"
    t.index ["business_category_id"], name: "index_business_counters_on_business_category_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "trans_code"
    t.string   "inst_no"
    t.string   "term_no"
    t.integer  "counter_counter"
    t.boolean  "enable"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "appointments", "business_categories"
  add_foreign_key "business_counters", "business_categories"
end
