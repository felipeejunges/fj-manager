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

ActiveRecord::Schema[7.0].define(version: 2023_10_14_423128) do
  create_table "client_invoices", force: :cascade do |t|
    t.string "description"
    t.string "payment_type"
    t.date "reference_date"
    t.integer "status"
    t.datetime "payed_date"
    t.float "invoice_value"
    t.integer "max_retries", default: 10
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_invoices_on_client_id"
  end

  create_table "client_plans", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "price", default: 0.0
    t.boolean "signable", default: true
    t.boolean "sale", default: false
    t.string "code"
    t.datetime "start_date", default: "2023-10-14 19:03:47"
    t.datetime "end_date"
    t.integer "billable_period", default: 0
    t.float "max_discount", default: 100.0
    t.boolean "commissionable", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "document"
    t.integer "document_type"
    t.string "payment_type"
    t.integer "payment_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "discount", default: 0.0
    t.string "email"
    t.integer "client_plan_id"
    t.integer "created_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "client_invoices", "clients"
  add_foreign_key "clients", "client_plans"
  add_foreign_key "clients", "users", column: "created_by_id"
end
