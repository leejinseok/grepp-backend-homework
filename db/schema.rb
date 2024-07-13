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

ActiveRecord::Schema[7.1].define(version: 2024_07_13_021919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exams", force: :cascade do |t|
    t.string "title", default: "그렙 코딩테스트", null: false
    t.bigint "reserved_user_id", null: false
    t.datetime "start_date_time", precision: nil, default: -> { "now()" }
    t.datetime "end_date_tie", precision: nil, default: -> { "now()" }
    t.integer "limit_user_count", default: 10000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reserved_user_id"], name: "index_exams_on_reserved_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "grepp@grepp.com", null: false
    t.string "name", default: "김그랩", null: false
    t.string "role", default: "user", null: false
    t.string "password", default: "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "exams", "users", column: "reserved_user_id", name: "fk_exams_1"
end
