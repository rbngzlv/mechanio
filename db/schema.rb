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

ActiveRecord::Schema.define(version: 20131010145320) do

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "body_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cars", force: true do |t|
    t.integer  "user_id"
    t.integer  "model_variation_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_title"
  end

  create_table "fixed_amounts", force: true do |t|
    t.string   "description"
    t.decimal  "cost",        precision: 8, scale: 2
    t.decimal  "tax",         precision: 8, scale: 2
    t.decimal  "total",       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.integer  "user_id"
    t.integer  "car_id"
    t.integer  "location_id"
    t.integer  "mechanic_id"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.decimal  "cost",              precision: 8, scale: 2
    t.decimal  "tax",               precision: 8, scale: 2
    t.decimal  "total",             precision: 8, scale: 2
    t.text     "serialized_params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "title"
  end

  create_table "labours", force: true do |t|
    t.text     "description"
    t.integer  "duration"
    t.decimal  "hourly_rate", precision: 8, scale: 2
    t.decimal  "cost",        precision: 8, scale: 2
    t.decimal  "tax",         precision: 8, scale: 2
    t.decimal  "total",       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "address"
    t.string   "suburb"
    t.string   "postcode"
    t.integer  "state_id"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_type"
    t.decimal  "latitude",       precision: 12, scale: 8
    t.decimal  "longitude",      precision: 12, scale: 8
  end

  create_table "makes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mechanics", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.date     "dob"
    t.text     "description"
    t.string   "driver_license_number"
    t.integer  "license_state_id"
    t.date     "license_expiry"
    t.string   "avatar"
    t.string   "driver_license"
    t.string   "abn"
    t.string   "mechanic_license"
    t.string   "abn_name"
    t.string   "business_website"
    t.string   "business_email"
    t.integer  "years_as_a_mechanic"
    t.string   "mobile_number"
    t.string   "other_number"
    t.string   "abn_number"
    t.date     "abn_expiry"
    t.string   "mechanic_license_number"
    t.date     "mechanic_license_expiry"
    t.string   "mechanic_license_state_id"
    t.boolean  "phone_verified",            default: false
    t.boolean  "super_mechanic",            default: false
    t.boolean  "warranty_covered",          default: false
    t.boolean  "qualification_verified",    default: false
  end

  add_index "mechanics", ["email"], name: "index_mechanics_on_email", unique: true, using: :btree
  add_index "mechanics", ["reset_password_token"], name: "index_mechanics_on_reset_password_token", unique: true, using: :btree

  create_table "model_variations", force: true do |t|
    t.string   "title"
    t.string   "identifier"
    t.integer  "model_id"
    t.integer  "body_type_id"
    t.integer  "from_year"
    t.integer  "to_year"
    t.string   "transmission"
    t.string   "fuel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "make_id"
    t.string   "display_title"
    t.text     "comment"
    t.string   "detailed_title"
  end

  create_table "models", force: true do |t|
    t.string   "name"
    t.integer  "make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.string   "name"
    t.integer  "quantity"
    t.decimal  "cost",       precision: 8, scale: 2
    t.decimal  "tax",        precision: 8, scale: 2
    t.decimal  "total",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unit_cost",  precision: 8, scale: 2
  end

  create_table "service_plans", force: true do |t|
    t.string   "title"
    t.integer  "kms_travelled"
    t.integer  "months"
    t.decimal  "cost",               precision: 8, scale: 2
    t.integer  "make_id"
    t.integer  "model_id"
    t.integer  "model_variation_id"
    t.text     "inclusions"
    t.text     "instructions"
    t.text     "parts"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_title"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "symptom_categories", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "symptoms", force: true do |t|
    t.integer  "symptom_category_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "symptoms_tasks", id: false, force: true do |t|
    t.integer "task_id",    null: false
    t.integer "symptom_id", null: false
  end

  create_table "task_items", force: true do |t|
    t.integer "task_id"
    t.integer "itemable_id"
    t.string  "itemable_type"
  end

  create_table "tasks", force: true do |t|
    t.string   "type"
    t.integer  "job_id"
    t.integer  "service_plan_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.decimal  "cost",            precision: 8, scale: 2
    t.decimal  "tax",             precision: 8, scale: 2
    t.decimal  "total",           precision: 8, scale: 2
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.date     "dob"
    t.string   "mobile_number"
    t.text     "description"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
