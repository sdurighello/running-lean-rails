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

ActiveRecord::Schema.define(version: 20160926125302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "area_identifier"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "canvas_id"
    t.index ["canvas_id"], name: "index_areas_on_canvas_id", using: :btree
  end

  create_table "areas_hypotheses", id: false, force: :cascade do |t|
    t.integer "area_id",       null: false
    t.integer "hypothesis_id", null: false
  end

  create_table "canvases", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "customers_to_break_even"
    t.decimal  "payback_period"
    t.decimal  "gross_margin"
    t.decimal  "market_size"
    t.integer  "customer_pain_level"
    t.integer  "market_ease_of_reach"
    t.integer  "feasibility"
    t.integer  "riskiness"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "project_id"
    t.index ["project_id"], name: "index_canvases_on_project_id", using: :btree
  end

  create_table "experiments", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "completed"
    t.string   "status"
    t.integer  "interviews_planned"
    t.integer  "interviews_done"
    t.integer  "early_adopters_planned"
    t.integer  "early_adopters_converted"
    t.text     "today_solution"
    t.decimal  "price_proposed"
    t.integer  "price_acceptance"
    t.decimal  "price_revised"
    t.integer  "sean_ellis_test"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "phase_id"
    t.index ["phase_id"], name: "index_experiments_on_phase_id", using: :btree
  end

  create_table "experiments_sprints", id: false, force: :cascade do |t|
    t.integer "experiment_id", null: false
    t.integer "sprint_id",     null: false
  end

  create_table "experiments_users", id: false, force: :cascade do |t|
    t.integer "experiment_id", null: false
    t.integer "user_id",       null: false
  end

  create_table "hypotheses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "area_identifier"
    t.integer  "project_id"
    t.index ["project_id"], name: "index_hypotheses_on_project_id", using: :btree
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
    t.integer  "project_id"
    t.index ["project_id"], name: "index_phases_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "current_phase_id"
    t.integer  "created_by_id"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id",    null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer  "validation_level"
    t.integer  "priority"
    t.integer  "pain_level"
    t.text     "comment"
    t.integer  "experiment_id"
    t.integer  "hypothesis_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["experiment_id"], name: "index_results_on_experiment_id", using: :btree
    t.index ["hypothesis_id"], name: "index_results_on_hypothesis_id", using: :btree
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
    t.integer  "phase_id"
    t.index ["phase_id"], name: "index_sprints_on_phase_id", using: :btree
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
    t.string   "name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "areas", "canvases"
  add_foreign_key "canvases", "projects"
  add_foreign_key "experiments", "phases"
  add_foreign_key "hypotheses", "projects"
  add_foreign_key "phases", "projects"
  add_foreign_key "results", "experiments"
  add_foreign_key "results", "hypotheses"
  add_foreign_key "sprints", "phases"
end
