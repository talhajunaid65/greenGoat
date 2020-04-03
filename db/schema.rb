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

ActiveRecord::Schema.define(version: 2020_04_03_181710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.bigint "task_id"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_activities_on_project_id"
    t.index ["task_id"], name: "index_activities_on_task_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "role"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "types", default: [], array: true
    t.text "capacities", default: [], array: true
    t.integer "sub_category_id"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "errors", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.text "product_ids", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "group_items", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "product_ids", default: [], array: true
    t.float "price"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sold", default: false
    t.index ["project_id"], name: "index_group_items_on_project_id"
  end

  create_table "home_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "task_id"
    t.integer "created_by_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
    t.index ["task_id"], name: "index_notes_on_task_id"
  end

  create_table "orders", force: :cascade do |t|
    t.float "price"
    t.string "item_or_group"
    t.bigint "user_id"
    t.integer "item_id"
    t.string "payment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_statuses", force: :cascade do |t|
    t.bigint "product_id"
    t.string "old_status"
    t.integer "new_status"
    t.string "change_reason"
    t.bigint "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_product_statuses_on_admin_user_id"
    t.index ["product_id"], name: "index_product_statuses_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "room_id"
    t.boolean "need_uninstallation"
    t.float "appraised_value"
    t.string "description"
    t.integer "status"
    t.integer "count"
    t.string "uom"
    t.string "width"
    t.string "height"
    t.string "depth"
    t.string "make"
    t.string "model"
    t.string "serial"
    t.datetime "sale_date"
    t.datetime "pickup_date"
    t.datetime "uninstallation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.float "wood"
    t.float "ceramic"
    t.float "glass"
    t.float "metal"
    t.float "stone_plastic"
    t.integer "payment_status"
    t.integer "sub_category_id"
    t.bigint "category_id"
    t.float "weight", default: 0.0
    t.float "asking_price", default: 0.0
    t.float "adjusted_price", default: 0.0
    t.float "sale_price", default: 0.0
    t.float "other", default: 0.0
    t.string "product_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "project_products", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_project_products_on_product_id"
    t.index ["project_id"], name: "index_project_products_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "type_of_project"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "start_date"
    t.string "tracking_id"
    t.string "year_built"
    t.float "val_sf"
    t.float "estimated_value"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hot"
    t.integer "pm_id"
    t.integer "appraiser_id"
    t.integer "contractor_id"
    t.integer "architect_id"
    t.string "name"
    t.date "contract_date"
    t.text "access_info"
    t.bigint "zillow_location_id"
    t.bigint "user_id"
    t.datetime "visit_date"
    t.datetime "demo_date"
    t.string "sqft"
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["zillow_location_id"], name: "index_projects_on_zillow_location_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "status"
    t.string "phone"
    t.datetime "contact_date"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "visit_date"
    t.integer "payment_method"
    t.integer "sale_source"
    t.string "other_source"
    t.integer "pickup_status"
    t.boolean "need_delivery"
    t.string "delivery_address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.float "delivery_cost"
    t.datetime "delivery_date"
    t.float "sale_price"
    t.bigint "user_id"
    t.integer "pm_id"
    t.index ["product_id"], name: "index_sales_on_product_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "job_number"
    t.boolean "closed"
    t.string "estimated_time"
    t.datetime "start_date"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hot"
    t.integer "closed_by_id"
    t.date "closed_date"
    t.string "title"
    t.text "description"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "phone"
    t.string "phone_type"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.integer "role"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "dob"
    t.string "client_code"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "description"
    t.boolean "complete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  create_table "zillow_locations", force: :cascade do |t|
    t.integer "type_of_project"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "start_date"
    t.string "year_built"
    t.float "val_sf"
    t.float "estimated_value"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_zillow_locations_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notes", "tasks", on_delete: :cascade
  add_foreign_key "product_statuses", "admin_users"
  add_foreign_key "product_statuses", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "project_products", "products"
  add_foreign_key "project_products", "projects"
  add_foreign_key "projects", "users", on_delete: :cascade
  add_foreign_key "projects", "zillow_locations"
  add_foreign_key "sales", "products"
  add_foreign_key "wishlists", "users", on_delete: :cascade
end
