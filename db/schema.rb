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

ActiveRecord::Schema[8.0].define(version: 2024_12_23_161920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "animal_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "animals", force: :cascade do |t|
    t.string "nickname"
    t.string "surname"
    t.string "gender"
    t.date "arival_date"
    t.string "from_people"
    t.string "from_place"
    t.date "birth_year"
    t.string "birth_month"
    t.date "death_date"
    t.string "color"
    t.string "aviary"
    t.string "description"
    t.string "history"
    t.string "graduation"
    t.bigint "animal_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_type_id"], name: "index_animals_on_animal_type_id"
  end

  create_table "medical_procedures", force: :cascade do |t|
    t.date "date_complete"
    t.boolean "complete"
    t.date "date_planned"
    t.text "notes"
    t.bigint "animal_id", null: false
    t.bigint "procedure_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_medical_procedures_on_animal_id"
    t.index ["procedure_type_id"], name: "index_medical_procedures_on_procedure_type_id"
  end

  create_table "procedure_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "animals", "animal_types"
  add_foreign_key "medical_procedures", "animals"
  add_foreign_key "medical_procedures", "procedure_types"
  add_foreign_key "sessions", "users"
end
