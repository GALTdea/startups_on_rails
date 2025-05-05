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

ActiveRecord::Schema[8.0].define(version: 2025_05_05_200931) do
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
    t.integer "parent_id"
    t.string "slug"
    t.text "description"
    t.index ["category_type"], name: "index_categories_on_category_type"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "categories_companies", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "categorizables", force: :cascade do |t|
    t.integer "categorizable_id", null: false
    t.string "categorizable_type", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categorizable_id", "categorizable_type", "category_id"], name: "index_categorizables_uniqueness", unique: true
    t.index ["categorizable_id", "categorizable_type"], name: "idx_on_categorizable_id_categorizable_type_9d4ee3164d"
    t.index ["category_id"], name: "index_categorizables_on_category_id"
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

  create_table "companies_technologies", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "technology_id", null: false
    t.index ["company_id", "technology_id"], name: "index_companies_technologies_on_company_id_and_technology_id", unique: true
    t.index ["technology_id", "company_id"], name: "index_companies_technologies_on_technology_id_and_company_id"
  end

  create_table "company_technologies", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "technology_id", null: false
    t.string "proficiency_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "technology_id"], name: "index_company_technologies_on_company_id_and_technology_id", unique: true
    t.index ["company_id"], name: "index_company_technologies_on_company_id"
    t.index ["technology_id"], name: "index_company_technologies_on_technology_id"
  end

  create_table "featured_listing_items", force: :cascade do |t|
    t.bigint "featured_listing_id", null: false
    t.string "featurable_type", null: false
    t.bigint "featurable_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featurable_type", "featurable_id"], name: "index_featured_listing_items_on_featurable"
    t.index ["featured_listing_id", "featurable_type", "featurable_id"], name: "index_featured_listing_items_on_featured_listing_and_featurable", unique: true
    t.index ["featured_listing_id", "position"], name: "idx_on_featured_listing_id_position_3ca29dfe9c"
    t.index ["featured_listing_id"], name: "index_featured_listing_items_on_featured_listing_id"
  end

  create_table "featured_listings", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "category_id", null: false
    t.integer "position", default: 0
    t.boolean "active", default: true
    t.datetime "featured_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "featured_item_type"
    t.integer "featured_item_id"
    t.string "featurable_type"
    t.bigint "featurable_id"
    t.index ["active"], name: "index_featured_listings_on_active"
    t.index ["category_id"], name: "index_featured_listings_on_category_id"
    t.index ["featurable_type", "featurable_id"], name: "index_featured_listings_on_featurable"
    t.index ["featured_item_type", "featured_item_id"], name: "index_featured_listings_on_featured_item"
    t.index ["position"], name: "index_featured_listings_on_position"
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
    t.bigint "company_id"
    t.string "target_audience", comment: "Primary user persona (Technical, Non-technical, Marketing, etc.)"
    t.string "technical_complexity", comment: "Implementation difficulty (No-code, Low-code, Technical)"
    t.string "support_level", comment: "Level of support provided (Self-service, Email/chat, etc.)"
    t.string "geographical_availability", default: "Global", comment: "Regions where the solution is available"
    t.string "customer_size", comment: "Ideal company size for the solution"
    t.index ["company_id"], name: "index_solutions_on_company_id"
    t.index ["customer_size"], name: "index_solutions_on_customer_size"
    t.index ["deployment_type"], name: "index_solutions_on_deployment_type"
    t.index ["geographical_availability"], name: "index_solutions_on_geographical_availability"
    t.index ["name"], name: "index_solutions_on_name"
    t.index ["popularity"], name: "index_solutions_on_popularity"
    t.index ["solution_type"], name: "index_solutions_on_solution_type"
    t.index ["support_level"], name: "index_solutions_on_support_level"
    t.index ["target_audience"], name: "index_solutions_on_target_audience"
    t.index ["technical_complexity"], name: "index_solutions_on_technical_complexity"
  end

  create_table "solutions_technologies", id: false, force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "technology_id", null: false
    t.index ["solution_id", "technology_id"], name: "index_solutions_technologies_on_solution_id_and_technology_id", unique: true
    t.index ["technology_id", "solution_id"], name: "index_solutions_technologies_on_technology_id_and_solution_id"
  end

  create_table "taggables", force: :cascade do |t|
    t.integer "taggable_id", null: false
    t.string "taggable_type", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggables_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "index_taggables_uniqueness", unique: true
    t.index ["taggable_id", "taggable_type"], name: "index_taggables_on_taggable_id_and_taggable_type"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.integer "popularity"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_technologies_on_name", unique: true
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
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "categorizables", "categories"
  add_foreign_key "companies", "users"
  add_foreign_key "company_technologies", "companies"
  add_foreign_key "company_technologies", "technologies"
  add_foreign_key "featured_listing_items", "featured_listings"
  add_foreign_key "featured_listings", "categories"
  add_foreign_key "solution_categories_solutions", "solution_categories"
  add_foreign_key "solution_categories_solutions", "solutions"
  add_foreign_key "solutions", "companies"
  add_foreign_key "taggables", "tags"
end
