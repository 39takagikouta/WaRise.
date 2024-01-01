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

ActiveRecord::Schema[7.0].define(version: 2024_01_01_084615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarms", force: :cascade do |t|
    t.datetime "wake_up_time", null: false
    t.string "custom_video_url"
    t.boolean "is_successful"
    t.string "factor"
    t.datetime "sleep_start_time"
    t.datetime "sleep_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "bootcamp_id"
    t.string "comment"
    t.string "job_id"
    t.index ["bootcamp_id"], name: "index_alarms_on_bootcamp_id"
    t.index ["job_id"], name: "index_alarms_on_job_id", unique: true
    t.index ["user_id"], name: "index_alarms_on_user_id"
  end

  create_table "bootcamps", force: :cascade do |t|
    t.datetime "start_day", null: false
    t.string "reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comedy_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_comedy_tags_on_name", unique: true
  end

  create_table "keywords", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_keywords_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_keywords_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alarm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alarm_id"], name: "index_likes_on_alarm_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "user_comedy_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "comedy_tag_id"
    t.index ["comedy_tag_id"], name: "index_user_comedy_tags_on_comedy_tag_id"
    t.index ["user_id", "comedy_tag_id"], name: "index_user_comedy_tags_on_user_id_and_comedy_tag_id", unique: true
    t.index ["user_id"], name: "index_user_comedy_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_automatically_posted", default: false
    t.boolean "is_displayed", default: true, null: false
    t.string "line_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "video_length", default: 0
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "viewed_videos", force: :cascade do |t|
    t.string "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "alarm_id"
    t.index ["alarm_id"], name: "index_viewed_videos_on_alarm_id"
    t.index ["user_id", "alarm_id", "video_id"], name: "index_viewed_videos_on_user_id_and_alarm_id_and_video_id", unique: true
    t.index ["user_id", "video_id"], name: "index_viewed_videos_on_user_id_and_video_id", unique: true
    t.index ["user_id"], name: "index_viewed_videos_on_user_id"
  end

  add_foreign_key "alarms", "bootcamps"
  add_foreign_key "alarms", "users"
  add_foreign_key "keywords", "users"
  add_foreign_key "likes", "alarms"
  add_foreign_key "likes", "users"
  add_foreign_key "user_comedy_tags", "comedy_tags"
  add_foreign_key "user_comedy_tags", "users"
  add_foreign_key "viewed_videos", "alarms"
  add_foreign_key "viewed_videos", "users"
end
