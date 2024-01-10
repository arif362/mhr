# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190125075903) do

  create_table "access_rights", force: :cascade do |t|
    t.integer  "employee_id",        limit: 4
    t.text     "permissions",        limit: 65535
    t.text     "custom_permissions", limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "access_rights", ["employee_id"], name: "index_access_rights_on_employee_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "attendance_attendance_logs", force: :cascade do |t|
    t.string   "ip_address",    limit: 255
    t.integer  "attendance_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "attendance_attendances", force: :cascade do |t|
    t.date     "in_date"
    t.datetime "in_time"
    t.datetime "out_time"
    t.float    "duration",      limit: 24
    t.integer  "employee_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "department_id", limit: 4
  end

  create_table "attendance_day_offs", force: :cascade do |t|
    t.integer  "year",          limit: 4
    t.date     "date"
    t.string   "day_off_type",  limit: 255
    t.float    "hours",         limit: 24
    t.string   "title",         limit: 255
    t.integer  "department_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "department_id", limit: 4
    t.string   "name",          limit: 255
    t.string   "number",        limit: 255
    t.string   "bank_name",     limit: 255
    t.string   "bank_branch",   limit: 255
    t.float    "balance",       limit: 24
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "bank_accounts", ["department_id"], name: "index_bank_accounts_on_department_id", using: :btree

  create_table "billing_client_contacts", force: :cascade do |t|
    t.integer  "client_id",     limit: 4
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "email",         limit: 255
    t.string   "home_phone",    limit: 255
    t.string   "mobile_number", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "billing_clients", force: :cascade do |t|
    t.string   "organization_name", limit: 255
    t.integer  "department_id",     limit: 4
    t.string   "email",             limit: 255
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "home_phone",        limit: 255
    t.string   "mobile_number",     limit: 255
    t.string   "send_invoice_by",   limit: 255
    t.string   "country",           limit: 255
    t.string   "address_street1",   limit: 255
    t.string   "address_street2",   limit: 255
    t.string   "city",              limit: 255
    t.string   "province_state",    limit: 255
    t.string   "postal_zip_code",   limit: 255
    t.string   "industry",          limit: 255
    t.string   "company_size",      limit: 255
    t.string   "business_phone",    limit: 255
    t.string   "fax",               limit: 255
    t.text     "internal_notes",    limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "billing_invoice_line_items", force: :cascade do |t|
    t.integer  "invoice_id",       limit: 4
    t.integer  "item_id",          limit: 4
    t.string   "item_name",        limit: 255
    t.string   "item_description", limit: 255
    t.decimal  "item_unit_cost",               precision: 10, scale: 2
    t.decimal  "item_quantity",                precision: 10, scale: 2
    t.integer  "tax_1",            limit: 4
    t.integer  "tax_2",            limit: 4
    t.string   "archive_number",   limit: 255
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.decimal  "actual_price",                 precision: 10, scale: 2, default: 0.0
    t.integer  "estimate_id",      limit: 4
  end

  create_table "billing_invoices", force: :cascade do |t|
    t.string   "invoice_number",      limit: 255
    t.datetime "invoice_date"
    t.string   "po_number",           limit: 255
    t.decimal  "discount_percentage",               precision: 10, scale: 2
    t.integer  "client_id",           limit: 4
    t.text     "terms",               limit: 65535
    t.text     "notes",               limit: 65535
    t.string   "item",                limit: 255
    t.string   "status",              limit: 255
    t.decimal  "sub_total",                         precision: 10, scale: 2
    t.decimal  "discount_amount",                   precision: 10, scale: 2
    t.decimal  "tax_amount",                        precision: 10, scale: 2
    t.decimal  "invoice_total",                     precision: 10, scale: 2
    t.string   "archive_number",      limit: 255
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.integer  "payment_terms_id",    limit: 4
    t.date     "due_date"
    t.string   "last_invoice_status", limit: 255
    t.string   "discount_type",       limit: 255
    t.integer  "department_id",       limit: 4
    t.integer  "project_id",          limit: 4
    t.string   "invoice_type",        limit: 255
    t.string   "currency",            limit: 255,                            default: "USD"
  end

  create_table "billing_payment_terms", force: :cascade do |t|
    t.integer  "number_of_days", limit: 4
    t.string   "description",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "billing_payments", force: :cascade do |t|
    t.integer  "invoice_id",                limit: 4
    t.decimal  "payment_amount",                          precision: 8,  scale: 2
    t.string   "payment_type",              limit: 255
    t.string   "payment_method",            limit: 255
    t.date     "payment_date"
    t.text     "notes",                     limit: 65535
    t.boolean  "send_payment_notification"
    t.boolean  "paid_full"
    t.string   "archive_number",            limit: 255
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.decimal  "credit_applied",                          precision: 10, scale: 2
    t.integer  "client_id",                 limit: 4
    t.integer  "company_id",                limit: 4
  end

  create_table "changed_settings", force: :cascade do |t|
    t.time     "open_time"
    t.time     "close_time"
    t.float    "working_hours", limit: 24
    t.date     "from_date"
    t.date     "to_date"
    t.integer  "department_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "changed_settings", ["department_id"], name: "fk_rails_70c51b74b1", using: :btree

  create_table "community_categories", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.boolean  "is_active",                 default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "slug",        limit: 255
  end

  create_table "community_comments", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.integer  "post_id",      limit: 4
    t.integer  "author_id",    limit: 4
    t.string   "attachment",   limit: 255
    t.boolean  "is_published",               default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "community_posts", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.integer  "community_category_id", limit: 4
    t.text     "content",               limit: 65535
    t.string   "attachment",            limit: 255
    t.integer  "author_id",             limit: 4
    t.boolean  "is_published",                        default: true
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "slug",                  limit: 255
  end

  create_table "companies", force: :cascade do |t|
    t.string  "name",          limit: 255
    t.string  "image",         limit: 255
    t.integer "employee_id",   limit: 4
    t.string  "mobile",        limit: 255
    t.string  "contact_email", limit: 255
    t.string  "address",       limit: 255
    t.string  "city",          limit: 255
    t.string  "state",         limit: 255
    t.string  "zip_code",      limit: 255
    t.string  "country",       limit: 255
    t.string  "next_path",     limit: 255
    t.string  "url",           limit: 255
    t.string  "custom_url",    limit: 255
  end

  create_table "company_features", force: :cascade do |t|
    t.integer  "feature_id", limit: 4
    t.integer  "company_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "contact_us", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "subject",    limit: 65535
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id",  limit: 4
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "image",       limit: 255
    t.integer  "company_id",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "address",     limit: 65535
    t.string   "slug",        limit: 255
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "zip_code",    limit: 255
    t.string   "country",     limit: 255
    t.string   "email",       limit: 255
    t.string   "mobile",      limit: 255
  end

  create_table "designations", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.boolean  "is_active",                   default: false
    t.integer  "department_id", limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "email",                       limit: 255,   default: "",      null: false
    t.string   "encrypted_password",          limit: 255,   default: ""
    t.string   "reset_password_token",        limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",          limit: 255
    t.string   "last_sign_in_ip",             limit: 255
    t.string   "confirmation_token",          limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",           limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "first_name",                  limit: 255
    t.string   "last_name",                   limit: 255
    t.text     "note",                        limit: 65535
    t.string   "location",                    limit: 255
    t.date     "dob"
    t.text     "address",                     limit: 65535
    t.string   "gender",                      limit: 255
    t.string   "image",                       limit: 255
    t.integer  "department_id",               limit: 4
    t.string   "role",                        limit: 255,   default: "staff"
    t.string   "invitation_token",            limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",            limit: 4
    t.integer  "invited_by_id",               limit: 4
    t.string   "invited_by_type",             limit: 255
    t.string   "blood_group",                 limit: 255
    t.date     "joining_date"
    t.integer  "designation_id",              limit: 4
    t.float    "basic_salary",                limit: 24
    t.string   "mobile",                      limit: 255
    t.string   "nid",                         limit: 255
    t.string   "kin_name",                    limit: 255
    t.string   "kin_contact",                 limit: 255
    t.boolean  "is_active",                                 default: true
    t.integer  "deactivated_by",              limit: 4
    t.date     "deactivate_date"
    t.string   "id_card_no",                  limit: 255
    t.string   "employee_type",               limit: 255
    t.string   "present_address",             limit: 255
    t.string   "permanent_address",           limit: 255
    t.string   "color",                       limit: 255
    t.string   "slug",                        limit: 255
    t.string   "kin_relationship",            limit: 255
    t.string   "marital_status",              limit: 255
    t.string   "nationality",                 limit: 255
    t.string   "country",                     limit: 255
    t.string   "attachment",                  limit: 255
    t.string   "bank_account_number",         limit: 255
    t.text     "bank_details",                limit: 65535
    t.string   "previous_employment_history", limit: 255
    t.string   "religion",                    limit: 255
  end

  add_index "employees", ["confirmation_token"], name: "index_employees_on_confirmation_token", unique: true, using: :btree
  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["invitation_token"], name: "index_employees_on_invitation_token", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "employees_advance_returns", force: :cascade do |t|
    t.date     "date"
    t.float    "amount",        limit: 24
    t.integer  "employee_id",   limit: 4
    t.integer  "department_id", limit: 4
    t.integer  "advance_id",    limit: 4
    t.integer  "salary_id",     limit: 4
    t.string   "return_from",   limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "employees_advances", force: :cascade do |t|
    t.integer  "employee_id",    limit: 4
    t.float    "amount",         limit: 24
    t.boolean  "is_paid",                      default: false
    t.text     "purpose",        limit: 65535
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "department_id",  limit: 4
    t.boolean  "is_deactivated",               default: false
    t.boolean  "is_completed",                 default: false
    t.float    "installment",    limit: 24
    t.string   "return_policy",  limit: 255
    t.date     "date"
  end

  create_table "expense_budgets", force: :cascade do |t|
    t.integer  "category_id",   limit: 4
    t.integer  "department_id", limit: 4
    t.integer  "company_id",    limit: 4
    t.integer  "year",          limit: 4
    t.float    "amount",        limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "description",         limit: 65535
    t.integer  "department_id",       limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "expense_category_id", limit: 4
  end

  create_table "expense_expenses", force: :cascade do |t|
    t.text     "description",             limit: 65535
    t.integer  "expense_category_id",     limit: 4
    t.integer  "expense_sub_category_id", limit: 4
    t.float    "amount",                  limit: 24
    t.integer  "department_id",           limit: 4
    t.date     "date"
    t.boolean  "is_approved",                           default: false
    t.integer  "created_by_id",           limit: 4
    t.integer  "approved_by_id",          limit: 4
    t.string   "received_by",             limit: 255
    t.string   "attachment",              limit: 255
    t.string   "payment_method",          limit: 255
    t.string   "status",                  limit: 255,   default: "pending"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.text     "voucher_number",          limit: 65535
  end

  create_table "features", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.float    "cost",        limit: 24
    t.text     "description", limit: 65535
    t.string   "app_module",  limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "url",         limit: 255
    t.string   "logo",        limit: 255
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.integer  "design",     limit: 4
    t.integer  "response",   limit: 4
    t.integer  "functional", limit: 4
    t.integer  "overall",    limit: 4
    t.float    "rate",       limit: 24
    t.text     "comments",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "leave_applications", force: :cascade do |t|
    t.text     "message",           limit: 65535
    t.text     "note",              limit: 65535
    t.string   "attachment",        limit: 255
    t.integer  "employee_id",       limit: 4
    t.integer  "leave_category_id", limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "department_id",     limit: 4
    t.integer  "total_days",        limit: 4
    t.boolean  "is_approved",                     default: false
    t.string   "status",            limit: 255,   default: "pending"
    t.boolean  "is_paid",                         default: false
  end

  create_table "leave_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "department_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.text     "description",   limit: 65535
    t.boolean  "is_active",                   default: true
  end

  create_table "leave_category_years", force: :cascade do |t|
    t.integer  "department_id",     limit: 4
    t.integer  "leave_category_id", limit: 4
    t.integer  "year",              limit: 4
    t.integer  "days",              limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "leave_days", force: :cascade do |t|
    t.date     "day"
    t.integer  "leave_application_id", limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "is_approved",                    default: false
  end

  create_table "payroll_bonus_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.boolean  "is_amount",                   default: true
    t.float    "amount",        limit: 24
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "department_id", limit: 4
    t.text     "message",       limit: 65535
  end

  add_index "payroll_bonus_categories", ["department_id"], name: "index_payroll_bonus_categories_on_department_id", using: :btree

  create_table "payroll_bonus_payments", force: :cascade do |t|
    t.string   "reason",         limit: 255
    t.text     "message",        limit: 65535
    t.float    "amount",         limit: 24
    t.integer  "employee_id",    limit: 4
    t.integer  "department_id",  limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "payment_method", limit: 255
    t.date     "date"
  end

  create_table "payroll_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.integer  "department_id", limit: 4
    t.boolean  "is_add",                      default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "is_percentage",               default: true
  end

  create_table "payroll_employee_categories", force: :cascade do |t|
    t.integer  "employee_id", limit: 4
    t.integer  "category_id", limit: 4
    t.float    "amount",      limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.float    "percentage",  limit: 24
  end

  create_table "payroll_increments", force: :cascade do |t|
    t.integer  "employee_id",      limit: 4
    t.integer  "department_id",    limit: 4
    t.float    "present_basic",    limit: 24
    t.float    "previous_basic",   limit: 24
    t.boolean  "is_active"
    t.date     "active_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "incremented_by",   limit: 255
    t.float    "increment_amount", limit: 24
  end

  create_table "payroll_salaries", force: :cascade do |t|
    t.integer  "employee_id",        limit: 4
    t.integer  "department_id",      limit: 4
    t.string   "payment_method",     limit: 255
    t.text     "addition_category",  limit: 65535
    t.float    "bonus",              limit: 24
    t.float    "total",              limit: 24
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.text     "deduction_category", limit: 65535
    t.integer  "month",              limit: 4
    t.integer  "year",               limit: 4
    t.float    "basic_salary",       limit: 24
    t.float    "total_addition",     limit: 24
    t.float    "total_deduction",    limit: 24
    t.boolean  "is_confirmed",                     default: true
    t.boolean  "from_combined",                    default: false
  end

  create_table "profile_pictures", force: :cascade do |t|
    t.integer "employee_id", limit: 4
    t.string  "image",       limit: 255
    t.boolean "is_active"
  end

  create_table "provident_fund_accounts", force: :cascade do |t|
    t.string   "number",         limit: 255
    t.integer  "rule_id",        limit: 4
    t.integer  "employee_id",    limit: 4
    t.date     "effective_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "department_id",  limit: 4
  end

  create_table "provident_fund_contributions", force: :cascade do |t|
    t.integer  "provident_fund_account_id", limit: 4
    t.float    "basis_salary",              limit: 24
    t.float    "employee_contribution",     limit: 24
    t.float    "company_contribution",      limit: 24
    t.integer  "month",                     limit: 4
    t.integer  "year",                      limit: 4
    t.boolean  "is_confirmed",                         default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "provident_fund_investments", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "pf_type",       limit: 255
    t.string   "amount",        limit: 255
    t.date     "maturity_date"
    t.float    "no_year",       limit: 24
    t.date     "date"
    t.float    "interest_rate", limit: 24
    t.integer  "no_day",        limit: 4
    t.integer  "department_id", limit: 4
    t.boolean  "active",                    default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "provident_fund_loan_returns", force: :cascade do |t|
    t.date     "date"
    t.float    "amount",        limit: 24
    t.integer  "department_id", limit: 4
    t.integer  "loan_id",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "provident_fund_loans", force: :cascade do |t|
    t.integer  "pf_account_id", limit: 4
    t.integer  "department_id", limit: 4
    t.float    "amount",        limit: 24
    t.text     "description",   limit: 65535
    t.string   "return_policy", limit: 255
    t.integer  "installment",   limit: 4
    t.date     "return_date"
    t.date     "date"
    t.boolean  "is_closed",                   default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "provident_fund_return_policies", force: :cascade do |t|
    t.float    "year",               limit: 24
    t.float    "company_percentage", limit: 24
    t.integer  "rule_id",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "provident_fund_rules", force: :cascade do |t|
    t.float    "company_contribution",  limit: 24
    t.string   "employee_contribution", limit: 255
    t.integer  "department_id",         limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "provident_fund_transactions", force: :cascade do |t|
    t.string   "transable_type", limit: 255
    t.integer  "transable_id",   limit: 4
    t.float    "debit",          limit: 24
    t.float    "credit",         limit: 24
    t.float    "pf_account_id",  limit: 24
    t.integer  "department_id",  limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "remarks", force: :cascade do |t|
    t.text     "message",         limit: 65535
    t.integer  "remarkable_id",   limit: 4
    t.string   "remarkable_type", limit: 255
    t.boolean  "is_seen",                       default: false
    t.boolean  "is_admin",                      default: true
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "remarked_by_id",  limit: 4
  end

  create_table "settings", force: :cascade do |t|
    t.time     "open_time"
    t.time     "close_time"
    t.float    "working_hours", limit: 24
    t.integer  "department_id", limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "time_zone",     limit: 255, default: "UTC"
    t.string   "currency",      limit: 255
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.integer  "employee_id",        limit: 4
    t.date     "date"
    t.boolean  "is_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_backlog_updated",             default: false
    t.date     "forward_to_date"
    t.date     "forward_from_date"
  end

  add_foreign_key "bank_accounts", "departments"
  add_foreign_key "changed_settings", "departments"
end
