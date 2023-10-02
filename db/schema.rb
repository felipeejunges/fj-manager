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

ActiveRecord::Schema[7.0].define(version: 2023_09_29_024420) do
  create_table "client_invoice_error_logs", force: :cascade do |t|
    t.integer "client_invoice_id", null: false
    t.integer "retry_number"
    t.datetime "date"
    t.string "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_invoice_id"], name: "index_client_invoice_error_logs_on_client_invoice_id"
  end

  create_table "client_invoices", force: :cascade do |t|
    t.string "description"
    t.string "payment_type"
    t.datetime "reference_date"
    t.integer "payment_day"
    t.integer "status"
    t.datetime "payed_date"
    t.float "invoice_value"
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_invoices_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "document"
    t.integer "document_type"
    t.string "payment_type"
    t.integer "payment_day"
    t.float "plan_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "password_confirmation"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "client_invoice_error_logs", "client_invoices"
  add_foreign_key "client_invoices", "clients"
end
