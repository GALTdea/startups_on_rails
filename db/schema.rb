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

ActiveRecord::Schema[8.0].define(version: 2025_03_04_224124) do
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "companies", "users"
  add_foreign_key "solution_categories_solutions", "solution_categories"
  add_foreign_key "solution_categories_solutions", "solutions"
end
