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

ActiveRecord::Schema.define(version: 20190707235035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "a_services", force: :cascade do |t|
    t.integer "vehicle_id"
    t.float "interval", default: 0.0
    t.float "last"
    t.float "near_mileage"
    t.float "dont_use_mileage"
    t.boolean "dont_use_near", default: false
    t.boolean "dont_use", default: false
    t.boolean "service_needed", default: false
  end

  create_table "air_filter_changes", force: :cascade do |t|
    t.integer "vehicle_id"
    t.float "interval", default: 0.0
    t.float "last"
    t.float "near_mileage"
    t.float "dont_use_mileage"
    t.boolean "dont_use_near", default: false
    t.boolean "dont_use", default: false
    t.boolean "service_needed", default: false
  end

  create_table "checklist_defects", force: :cascade do |t|
    t.integer "checklist_id"
    t.integer "defect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "brakes"
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
    t.boolean "defect"
    t.string "wash_old"
    t.string "suspension_old"
    t.string "drive_train_old"
    t.string "body_old"
    t.string "engine_old"
    t.string "brakes_old"
    t.string "safety_equipment_old"
    t.string "chassis_old"
    t.string "electrical_old"
    t.string "cooling_system_old"
    t.string "tires_old"
    t.string "radio_old"
    t.string "exhaust_old"
    t.string "steering_old"
    t.string "defect_ids_old", default: [], array: true
    t.string "name"
    t.string "checklist_type"
  end

  create_table "defect_requests", force: :cascade do |t|
    t.integer "defect_id"
    t.integer "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "defects", force: :cascade do |t|
    t.string "description"
    t.bigint "vehicle_id"
    t.boolean "fixed", default: false
    t.date "date_fixed", default: "2018-07-31"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: ""
    t.integer "times_reported"
    t.integer "last_event_reported"
    t.boolean "manually_reported"
    t.text "repair", default: ""
    t.text "notes", default: ""
    t.string "mechanic", default: ""
    t.integer "times_completed"
    t.integer "user_id"
    t.index ["vehicle_id"], name: "index_defects_on_vehicle_id"
  end

  create_table "event_reports", force: :cascade do |t|
    t.integer "event_id"
    t.integer "report_id"
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
    t.float "calc_mileage"
    t.date "end_date"
    t.boolean "multi_day"
    t.boolean "checklists_completed"
    t.boolean "defects_reported"
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
    t.string "vehicle_category"
    t.string "location", default: "RZR Basecamp"
    t.string "image"
  end

  create_table "program_requests", force: :cascade do |t|
    t.integer "program_id"
    t.integer "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "threshold"
    t.float "threshold_numb"
    t.float "rzr_interval", default: 0.0
    t.float "tour_car_interval", default: 0.0
    t.float "fleet_interval", default: 0.0
    t.float "training_interval", default: 0.0
    t.float "other_interval", default: 0.0
    t.float "db_interval", default: 0.0
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

  create_table "request_vehicles", force: :cascade do |t|
    t.integer "request_id"
    t.integer "vehicle_id"
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
    t.string "status"
    t.integer "checklist_id", default: 0
    t.string "mechanic", default: ""
    t.integer "times_completed", default: 0
    t.integer "mechanic_id"
    t.text "notes"
    t.boolean "a_service", default: false
    t.boolean "shock_service", default: false
    t.boolean "air_filter_service", default: false
    t.boolean "tour_car_prep", default: false
    t.boolean "defect", default: false
    t.boolean "repairs", default: false
    t.boolean "deadline", default: false
    t.boolean "multi_vehicle", default: false
  end

  create_table "rotation_metrics", force: :cascade do |t|
    t.integer "a_times_used"
    t.integer "b_times_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shock_services", force: :cascade do |t|
    t.integer "vehicle_id"
    t.float "interval", default: 0.0
    t.float "last"
    t.float "near_mileage"
    t.float "dont_use_mileage"
    t.boolean "dont_use_near", default: false
    t.boolean "dont_use", default: false
    t.boolean "service_needed", default: false
  end

  create_table "tour_car_preps", force: :cascade do |t|
    t.integer "vehicle_id"
    t.float "interval", default: 0.0
    t.float "last"
    t.float "near_mileage"
    t.float "dont_use_mileage"
    t.boolean "dont_use_near", default: false
    t.boolean "dont_use", default: false
    t.boolean "service_needed", default: false
    t.boolean "near", default: false
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
    t.boolean "subscribe", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "car_id", default: "Blank"
    t.string "manufacturer", default: "Blank"
    t.string "vin_number", default: "Blank"
    t.date "registration_date", default: "2018-07-31"
    t.string "plate_number", default: "Blank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.float "mileage"
    t.string "vehicle_status", default: "In-Service"
    t.boolean "needs_service", default: false
    t.boolean "near_service", default: false
    t.boolean "shock_service", default: false
    t.boolean "air_filter_service", default: false
    t.boolean "repair_needed", default: false
    t.boolean "defect", default: false
    t.string "make", default: "Blank"
    t.integer "year", default: 0
    t.string "color", default: "Blank"
    t.boolean "use_a", default: false
    t.boolean "dont_use_a_service", default: false
    t.boolean "dont_use_shock_service", default: false
    t.boolean "dont_use_air_filter_service", default: false
    t.boolean "use_near_service", default: false
    t.float "last_a_service", default: 0.0
    t.float "last_shock_service", default: 0.0
    t.float "last_air_filter_service", default: 0.0
    t.boolean "use_b", default: false
    t.integer "times_used", default: 0
    t.float "est_mileage"
    t.string "veh_category", default: "RZR"
    t.string "location", default: "RZR Basecamp"
    t.boolean "high_use", default: false
    t.string "notes", default: "Blank"
    t.date "sale_date", default: "2018-07-31"
    t.string "purchaser", default: "Blank"
    t.boolean "prep", default: false
    t.boolean "near_a_service", default: false
    t.boolean "near_shock_service", default: false
    t.boolean "near_air_filter_service", default: false
    t.float "near_a_service_mileage", default: 0.0
    t.float "near_shock_service_mileage", default: 0.0
    t.float "near_air_filter_service_mileage", default: 0.0
    t.float "a_service_interval", default: 0.0
    t.float "shock_service_interval", default: 0.0
    t.float "air_filter_service_interval", default: 0.0
    t.boolean "tour_car_prep", default: false
    t.float "last_tour_car_prep_mileage", default: 0.0
    t.float "tour_car_prep_interval", default: 0.0
    t.boolean "near_tour_car_prep", default: false
    t.float "near_tour_car_prep_mileage", default: 0.0
    t.boolean "dont_use_near_a_service", default: false
    t.boolean "dont_use_near_shock_service", default: false
    t.boolean "dont_use_near_air_filter_service", default: false
    t.boolean "dont_use_near_tour_car_prep", default: false
    t.float "dont_use_near_a_service_mileage", default: 0.0
    t.float "dont_use_near_shock_service_mileage", default: 0.0
    t.float "dont_use_near_air_filter_service_mileage", default: 0.0
    t.float "dont_use_near_tour_car_prep_mileage", default: 0.0
    t.boolean "dont_use_tour_car_prep", default: false
    t.boolean "a_service", default: false
    t.integer "times_used_year", default: 0
    t.boolean "work_orders_overdue", default: false
  end

  create_table "web_hooks", force: :cascade do |t|
    t.string "data"
    t.string "integration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
