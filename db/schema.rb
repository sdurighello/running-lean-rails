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

ActiveRecord::Schema.define(version: 20160914081850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "experiments", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "completed"
    t.string   "domain"
    t.text     "assumption"
    t.text     "method"
    t.text     "observation"
    t.text     "measure"
    t.text     "learned"
    t.text     "success_criteria"
    t.text     "action"
    t.integer  "interviews_planned"
    t.integer  "interviews_done"
    t.integer  "early_adopters_planned"
    t.integer  "early_adopters_converted"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "phases", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "sequence"
    t.integer  "number_of_sprints"
    t.integer  "sprint_length"
    t.boolean  "completed"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "completed"
    t.text     "things_done"
    t.text     "things_learned"
    t.integer  "stories_estimated"
    t.integer  "stories_completed"
    t.integer  "points_estimated"
    t.integer  "points_completed"
    t.integer  "happiness"
    t.text     "impediments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
