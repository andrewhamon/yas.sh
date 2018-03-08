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

ActiveRecord::Schema.define(version: 20170927223837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "accounts", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "accounts_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.index ["account_id", "user_id"], name: "index_accounts_users_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_accounts_users_on_account_id"
    t.index ["user_id", "account_id"], name: "index_accounts_users_on_user_id_and_account_id"
    t.index ["user_id"], name: "index_accounts_users_on_user_id"
  end

  create_table "files", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "md5", null: false
    t.bigint "size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "md5"], name: "index_files_on_account_id_and_md5", unique: true
    t.index ["account_id"], name: "index_files_on_account_id"
  end

  create_table "revision_files", force: :cascade do |t|
    t.bigint "revision_id", null: false
    t.bigint "file_id", null: false
    t.string "site_path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_id"], name: "index_revision_files_on_file_id"
    t.index ["revision_id", "site_path"], name: "index_revision_files_on_revision_id_and_site_path", unique: true
    t.index ["revision_id"], name: "index_revision_files_on_revision_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.integer "number", null: false
    t.bigint "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id", "number"], name: "index_revisions_on_site_id_and_number", unique: true
    t.index ["site_id"], name: "index_revisions_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "domain", null: false
    t.bigint "account_id", null: false
    t.integer "revision_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_revision_id"
    t.index ["account_id"], name: "index_sites_on_account_id"
    t.index ["current_revision_id"], name: "index_sites_on_current_revision_id"
    t.index ["domain"], name: "index_sites_on_domain", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", null: false
    t.string "password_digest", null: false
    t.string "jwt_salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
