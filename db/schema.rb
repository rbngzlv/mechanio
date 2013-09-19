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

ActiveRecord::Schema.define(version: 20130919071913) do

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
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.date     "dob"
    t.text     "description"
    t.text     "street_address"
    t.string   "suburb"
    t.integer  "state_id"
    t.string   "postcode"
    t.string   "driver_license"
    t.integer  "license_state_id"
    t.date     "license_expiry"
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
  end

  create_table "models", force: true do |t|
    t.string   "name"
    t.integer  "make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_plans", force: true do |t|
    t.string   "title"
    t.integer  "kms_travelled"
    t.integer  "months"
    t.decimal  "quote",              precision: 8, scale: 2
    t.integer  "make_id"
    t.integer  "model_id"
    t.integer  "model_variation_id"
    t.text     "inclusions"
    t.text     "instructions"
    t.text     "parts"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
