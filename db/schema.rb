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

ActiveRecord::Schema.define(version: 20160423165206) do

  create_table "locations", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pets", force: :cascade do |t|
    t.string   "name"
    t.integer  "race_id"
    t.string   "color"
    t.text     "about",      limit: 255
    t.string   "image"
    t.integer  "owner_id"
    t.boolean  "is_trained"
    t.date     "birthday"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pets", ["owner_id"], name: "index_pets_on_owner_id"
  add_index "pets", ["race_id"], name: "index_pets_on_race_id"

  create_table "races", force: :cascade do |t|
    t.string   "name"
    t.string   "about"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "races", ["name"], name: "index_races_on_name", unique: true

  create_table "reviews", force: :cascade do |t|
    t.integer  "rate",       limit: 2
    t.text     "feedback",   limit: 255
    t.integer  "user_id"
    t.integer  "writer_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"
  add_index "reviews", ["writer_id"], name: "index_reviews_on_writer_id"

  create_table "service_provider_skills", force: :cascade do |t|
    t.integer  "skill_id"
    t.integer  "service_provider_id"
    t.integer  "years_of_experience", limit: 2
    t.text     "details",             limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "service_provider_skills", ["service_provider_id"], name: "index_service_provider_skills_on_service_provider_id"
  add_index "service_provider_skills", ["skill_id"], name: "index_service_provider_skills_on_skill_id"

  create_table "service_requests", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "service_provider_id"
    t.integer  "status",              default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "service_requests", ["service_id"], name: "index_service_requests_on_service_id"
  add_index "service_requests", ["service_provider_id"], name: "index_service_requests_on_service_provider_id"

  create_table "services", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "pet_id"
    t.integer  "service_provider_id"
    t.datetime "time_start"
    t.datetime "time_end"
    t.integer  "status",              default: 0, null: false
    t.integer  "type",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "services", ["client_id"], name: "index_services_on_client_id"
  add_index "services", ["pet_id"], name: "index_services_on_pet_id"
  add_index "services", ["service_provider_id"], name: "index_services_on_service_provider_id"

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "token"
    t.string   "name"
    t.string   "phone",        limit: 13
    t.string   "type"
    t.integer  "location_id"
    t.text     "about",        limit: 255
    t.string   "image"
    t.decimal  "rating",                   precision: 2, scale: 2, default: 0.0
    t.integer  "rating_count",                                     default: 0
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["location_id"], name: "index_users_on_location_id"
  add_index "users", ["token"], name: "index_users_on_token"

end
