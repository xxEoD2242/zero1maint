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

ActiveRecord::Schema.define(version: 20171109180857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mileages", force: :cascade do |t|
    t.float "mileage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "number"
    t.text "description"
    t.text "special_requets"
    t.date "completion_date"
    t.string "poc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "user_id"
    t.integer "vehicle_id"
    t.integer "tracker_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackers", force: :cascade do |t|
    t.string "track"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.integer "emplyid"
    t.string "name"
    t.float "labor"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicle_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "car_id"
    t.string "manufacturer"
    t.integer "status"
    t.string "vin_number"
    t.date "registration_date"
    t.string "plate_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_category_id"
  end

end
