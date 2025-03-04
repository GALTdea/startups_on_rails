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

ActiveRecord::Schema[8.0].define(version: 2025_03_04_224932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_type"
    t.index ["category_type"], name: "index_categories_on_category_type"
  end

  create_table "categories_companies", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "description"
    t.string "website"
    t.string "location"
    t.string "slug"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_size"
    t.string "funding_stage"
    t.integer "employee_count"
    t.integer "year_founded"
    t.string "industry"
    t.index ["industry"], name: "index_companies_on_industry"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "companies_tags", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "tag_id", null: false
    t.index ["company_id", "tag_id"], name: "index_companies_tags_on_company_id_and_tag_id", unique: true
    t.index ["tag_id", "company_id"], name: "index_companies_tags_on_tag_id_and_company_id", unique: true
  end

  create_table "company_technologies", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "technology_id", null: false
    t.string "proficiency_level", default: "regular"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "technology_id"], name: "index_company_technologies_on_company_id_and_technology_id", unique: true
    t.index ["company_id"], name: "index_company_technologies_on_company_id"
    t.index ["technology_id"], name: "index_company_technologies_on_technology_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.string "favoritable_type", null: false
    t.bigint "favoritable_id", null: false
    t.string "favoritor_type", null: false
    t.bigint "favoritor_id", null: false
    t.string "scope", default: "favorite", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked"], name: "index_favorites_on_blocked"
    t.index ["favoritable_id", "favoritable_type"], name: "fk_favoritables"
    t.index ["favoritable_type", "favoritable_id", "favoritor_type", "favoritor_id", "scope"], name: "uniq_favorites__and_favoritables", unique: true
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable"
    t.index ["favoritor_id", "favoritor_type"], name: "fk_favorites"
    t.index ["favoritor_type", "favoritor_id"], name: "index_favorites_on_favoritor"
    t.index ["scope"], name: "index_favorites_on_scope"
  end

  create_table "solution_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solution_categories_solutions", force: :cascade do |t|
    t.bigint "solution_category_id", null: false
    t.bigint "solution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_category_id", "solution_id"], name: "index_solution_categories_solutions_unique", unique: true
    t.index ["solution_category_id"], name: "index_solution_categories_solutions_on_solution_category_id"
    t.index ["solution_id"], name: "index_solution_categories_solutions_on_solution_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "website"
    t.string "pricing"
    t.string "deployment_type"
    t.integer "popularity", default: 0
    t.string "solution_type"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deployment_type"], name: "index_solutions_on_deployment_type"
    t.index ["name"], name: "index_solutions_on_name"
    t.index ["popularity"], name: "index_solutions_on_popularity"
    t.index ["solution_type"], name: "index_solutions_on_solution_type"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.integer "popularity", default: 0
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_technologies_on_category"
    t.index ["name"], name: "index_technologies_on_name", unique: true
    t.index ["popularity"], name: "index_technologies_on_popularity"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wizard_options", force: :cascade do |t|
    t.bigint "wizard_question_id", null: false
    t.string "text"
    t.string "value"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wizard_question_id"], name: "index_wizard_options_on_wizard_question_id"
  end

  create_table "wizard_questions", force: :cascade do |t|
    t.string "text", null: false
    t.text "help_text"
    t.string "question_type", null: false
    t.integer "position", default: 0
    t.boolean "required", default: true
    t.integer "parent_id"
    t.string "dependent_value"
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_wizard_questions_on_identifier", unique: true
    t.index ["parent_id"], name: "index_wizard_questions_on_parent_id"
    t.index ["position"], name: "index_wizard_questions_on_position"
  end

  create_table "wizard_recommendations", force: :cascade do |t|
    t.bigint "wizard_session_id", null: false
    t.bigint "solution_id", null: false
    t.decimal "score"
    t.text "reasoning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "index_wizard_recommendations_on_solution_id"
    t.index ["wizard_session_id"], name: "index_wizard_recommendations_on_wizard_session_id"
  end

  create_table "wizard_responses", force: :cascade do |t|
    t.bigint "wizard_session_id", null: false
    t.bigint "wizard_question_id", null: false
    t.text "response_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wizard_question_id"], name: "index_wizard_responses_on_wizard_question_id"
    t.index ["wizard_session_id"], name: "index_wizard_responses_on_wizard_session_id"
  end

  create_table "wizard_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "session_identifier"
    t.boolean "completed"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wizard_sessions_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "companies", "users"
  add_foreign_key "company_technologies", "companies"
  add_foreign_key "company_technologies", "technologies"
  add_foreign_key "solution_categories_solutions", "solution_categories"
  add_foreign_key "solution_categories_solutions", "solutions"
  add_foreign_key "wizard_options", "wizard_questions"
  add_foreign_key "wizard_recommendations", "solutions"
  add_foreign_key "wizard_recommendations", "wizard_sessions"
  add_foreign_key "wizard_responses", "wizard_questions"
  add_foreign_key "wizard_responses", "wizard_sessions"
  add_foreign_key "wizard_sessions", "users"
end
