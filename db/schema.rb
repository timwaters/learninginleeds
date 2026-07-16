# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_07_16_092432) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "target_group"
    t.string "status"
    t.string "qualification"
    t.date "start_date"
    t.date "end_date"
    t.time "start_time"
    t.time "end_time"
    t.float "hours"
    t.integer "target_number"
    t.integer "enrolment_count"
    t.string "lcc_code"
    t.string "provider_code"
    t.string "academic_year"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "venue_id"
    t.bigint "provider_id"
    t.bigint "subject_id"
    t.float "latitude"
    t.float "longitude"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "category_1"
    t.string "category_2"
    t.bigint "import_id"
    t.text "description_rtf"
    t.text "description_html"
    t.string "short_link"
    t.index ["import_id"], name: "index_courses_on_import_id"
    t.index ["lcc_code"], name: "index_courses_on_lcc_code"
    t.index ["lonlat"], name: "index_courses_on_lonlat", using: :gist
    t.index ["provider_id"], name: "index_courses_on_provider_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["venue_id"], name: "index_courses_on_venue_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "status"
    t.integer "course_count"
    t.string "filename"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "csv_file_file_name"
    t.string "csv_file_content_type"
    t.integer "csv_file_file_size"
    t.datetime "csv_file_updated_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.integer "imported_num"
    t.text "note"
    t.string "upload_url"
    t.integer "rows_num"
    t.jsonb "error_log"
  end

  create_table "news", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "excerpt"
    t.string "title"
    t.string "thumbnail"
    t.boolean "visible", default: false
    t.string "alt_text"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "postcodes", force: :cascade do |t|
    t.string "postcode"
    t.integer "easting"
    t.integer "northing"
    t.float "latitude"
    t.float "longitude"
    t.string "postcode_no_space"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "telephone"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email"
    t.boolean "application_form", default: true
    t.boolean "visible", default: false
    t.text "body"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "thumbnail"
    t.text "body"
    t.text "excerpt"
    t.boolean "visible", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "alt_text"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subjects_topics", id: false, force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "subject_id"
    t.index ["subject_id"], name: "index_subjects_topics_on_subject_id"
    t.index ["topic_id"], name: "index_subjects_topics_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "category_1", default: [], array: true
    t.text "category_2", default: [], array: true
    t.integer "count_courses"
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at", precision: nil
    t.text "promotion"
    t.string "alt_text"
    t.integer "position"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "postcode"
    t.string "area"
    t.string "committee"
    t.string "ward"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "easting"
    t.integer "northing"
    t.string "postcode_no_space"
    t.string "address_1"
    t.string "address_2"
    t.string "address_3"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "courses", "imports"
  add_foreign_key "courses", "providers"
  add_foreign_key "courses", "subjects"
  add_foreign_key "courses", "venues"
end
