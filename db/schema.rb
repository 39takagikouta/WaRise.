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

ActiveRecord::Schema[7.0].define(version: 2023_10_12_081009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarms", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "bootcamp_id"
    t.datetime "wake_up_time", null: false
    t.string "custom_video_url"
    t.boolean "is_successful"
    t.string "factor"
    t.datetime "sleep_start_time"
    t.datetime "sleep_end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_automatically_posted"
    t.boolean "is_displayed", default: true
    t.string "line_user_id"
    t.integer "min_video_length"
    t.integer "max_video_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
