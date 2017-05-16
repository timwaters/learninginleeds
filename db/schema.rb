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

ActiveRecord::Schema.define(version: 20170516160807) do

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "target_group"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "venue_id"
    t.integer "provider_id"
    t.integer "subject_id"
    t.index ["provider_id"], name: "index_courses_on_provider_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["venue_id"], name: "index_courses_on_venue_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects_topics", id: false, force: :cascade do |t|
    t.integer "topic_id"
    t.integer "subject_id"
    t.index ["subject_id"], name: "index_subjects_topics_on_subject_id"
    t.index ["topic_id"], name: "index_subjects_topics_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "postcode"
    t.string "area"
    t.string "committee"
    t.string "ward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

end
