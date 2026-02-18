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

ActiveRecord::Schema[8.1].define(version: 2026_02_18_202649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "import_rows", force: :cascade do |t|
    t.string "building_name"
    t.string "city"
    t.datetime "created_at", null: false
    t.integer "import_id", null: false
    t.string "state"
    t.string "street_address"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["import_id"], name: "index_import_rows_on_import_id"
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "filename"
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "building_name"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "state"
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "zip"
  end

  create_table "units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "number"
    t.integer "property_id", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_units_on_property_id"
  end

  add_foreign_key "import_rows", "imports"
  add_foreign_key "units", "properties"
end
