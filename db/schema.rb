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

ActiveRecord::Schema.define(version: 20171219211553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
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
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "checklists", force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "user_id"
    t.string "fuel_level"
    t.string "wash"
    t.string "suspension"
    t.string "drive_train"
    t.string "body"
    t.string "engine"
    t.string "brake"
    t.string "safety_equipment"
    t.string "chassis"
    t.string "electrical"
    t.string "cooling_system"
    t.string "tires"
    t.string "radio"
    t.string "exhaust"
    t.string "steering"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
    t.date "date"
    t.integer "event_id"
    t.boolean "deadline"
  end

  create_table "event_reports", force: :cascade do |t|
    t.integer "event_id"
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_vehicles", force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.date "date"
    t.float "event_mileage"
    t.integer "location_id"
    t.float "duration"
    t.string "event_type"
    t.string "class_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "number"
    t.time "event_time"
    t.float "est_mileage"
    t.string "location"
    t.integer "customers"
    t.integer "shares"
    t.string "duration_word"
  end

  create_table "events_vehicles", force: :cascade do |t|
    t.integer "event_id"
    t.integer "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "part_items", force: :cascade do |t|
    t.integer "part_id"
    t.integer "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "request_id"
    t.float "part_item_total"
  end

  create_table "part_orders", force: :cascade do |t|
    t.integer "invoice_numb"
    t.integer "part_id"
    t.integer "quantity"
    t.string "brand"
    t.text "description"
    t.string "category"
    t.integer "user_id"
    t.string "vendor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_reports", force: :cascade do |t|
    t.integer "part_id"
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_requests", force: :cascade do |t|
    t.integer "part_id"
    t.integer "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string "description"
    t.string "brand"
    t.string "category"
    t.decimal "cost"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "quant_low"
    t.boolean "quant_none"
    t.integer "vehicle_category_id"
    t.string "part_numb"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.float "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
  end

  create_table "report_users", force: :cascade do |t|
    t.integer "report_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_vehicle_orders", force: :cascade do |t|
    t.integer "car_id"
    t.integer "report_id"
    t.boolean "needs_service"
    t.boolean "near_service"
    t.boolean "a_service"
    t.boolean "shock_service"
    t.boolean "air_filter_service"
    t.boolean "repair_needed"
    t.boolean "defect"
    t.string "location"
    t.string "vehicle_category"
    t.float "mileage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "request_miles"
    t.string "vehicle_status"
  end

  create_table "report_vehicles", force: :cascade do |t|
    t.integer "report_id"
    t.integer "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_status"
  end

  create_table "reports", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "report_type"
    t.string "report_doc"
  end

  create_table "request_part_orders", force: :cascade do |t|
    t.integer "request_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "order_items"
    t.float "order_total"
  end

  create_table "request_reports", force: :cascade do |t|
    t.integer "request_id"
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_users", force: :cascade do |t|
    t.integer "request_id"
    t.integer "user_id"
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
    t.float "request_mileage"
    t.integer "program_id"
    t.boolean "overdue"
    t.integer "checklist_numb"
    t.string "creator"
    t.date "completed_date"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.float "interval"
    t.date "completed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "vehicle_events", force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "car_id"
    t.string "manufacturer"
    t.string "vin_number"
    t.date "registration_date"
    t.string "plate_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.float "mileage"
    t.string "vehicle_status"
    t.boolean "needs_service"
    t.boolean "near_service"
    t.boolean "a_service"
    t.boolean "shock_service"
    t.boolean "air_filter_service"
    t.boolean "repair_needed"
    t.boolean "defect"
    t.string "make"
    t.integer "year"
    t.string "color"
    t.integer "vehicle_category_id"
    t.boolean "use_a"
    t.boolean "dont_use_a_service"
    t.boolean "dont_use_shock_service"
    t.boolean "dont_use_air_filter_service"
    t.boolean "use_near_service"
    t.float "last_a_service"
    t.float "last_shock_service"
    t.float "last_air_filter_service"
    t.boolean "use_b"
    t.integer "times_used"
    t.float "est_mileage"
    t.string "veh_category"
    t.string "location"
  end

end
