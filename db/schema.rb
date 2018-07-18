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

ActiveRecord::Schema.define(version: 20170527143653) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "account_type",                default: 0
    t.datetime "next_payment_date"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "update_url"
    t.string   "cancel_url"
    t.string   "subscription_status"
    t.string   "next_bill_date"
    t.integer  "paddle_subscription_id"
    t.integer  "paddle_subscription_plan_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "brief_html"
    t.text     "brief_md"
    t.text     "content_html"
    t.text     "content_md"
    t.boolean  "is_sponsored"
    t.boolean  "is_published"
    t.integer  "view_count"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "client_info"
    t.boolean  "answered",    default: false
  end

  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id"

  create_table "logins", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "logintime"
    t.string   "user_agent"
    t.string   "ip"
    t.integer  "oauth_profile_id"
    t.string   "browser"
    t.string   "version"
    t.string   "platform"
  end

  add_index "logins", ["oauth_profile_id"], name: "index_logins_on_oauth_profile_id"
  add_index "logins", ["user_id"], name: "index_logins_on_user_id"

  create_table "oauth_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "image_url"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "oauth_profiles", ["user_id"], name: "index_oauth_profiles_on_user_id"

  create_table "old_schemas", force: :cascade do |t|
    t.integer  "oldid"
    t.integer  "schema_id"
    t.datetime "import_date"
    t.string   "username"
    t.string   "name"
    t.boolean  "template",    default: false
    t.string   "db"
    t.string   "schema_data"
    t.boolean  "imported",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "old_schemas", ["schema_id"], name: "index_old_schemas_on_schema_id"

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.float    "sale_gross"
    t.float    "fee"
    t.float    "earnings"
    t.float    "payment_tax"
    t.string   "country"
    t.string   "currency"
    t.integer  "paddle_order_id"
    t.string   "next_bill_date"
    t.integer  "paddle_subscription_id"
    t.string   "email"
    t.integer  "paddle_subscription_plan_id"
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id"
  add_index "payments", ["user_id"], name: "index_payments_on_user_id"

  create_table "schema_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "schema_id"
    t.text     "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schema_comments", ["schema_id"], name: "index_schema_comments_on_schema_id"
  add_index "schema_comments", ["user_id"], name: "index_schema_comments_on_user_id"

  create_table "schema_versions", force: :cascade do |t|
    t.integer  "schema_id"
    t.text     "schema_data"
    t.integer  "user_id"
    t.boolean  "autosave",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "schema_versions", ["schema_id"], name: "index_schema_versions_on_schema_id"
  add_index "schema_versions", ["user_id"], name: "index_schema_versions_on_user_id"

  create_table "schemas", force: :cascade do |t|
    t.string   "title"
    t.string   "schema_data"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "template",              default: false
    t.boolean  "deleted",               default: false
    t.integer  "schema_versions_count", default: 0
    t.string   "db"
  end

  create_table "user_schemas", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "schema_id"
    t.integer  "access_mode", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_schemas", ["schema_id"], name: "index_user_schemas_on_schema_id"
  add_index "user_schemas", ["user_id"], name: "index_user_schemas_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invited",                 default: false
    t.integer  "account_id"
    t.integer  "schemas_count",           default: 0
    t.boolean  "deleted",                 default: false
    t.string   "app_settings"
    t.boolean  "newsletter_subscription", default: false
    t.string   "password_reset_digest"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id"

end
