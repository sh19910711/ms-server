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

ActiveRecord::Schema.define(version: 20161214231457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "user_id"
    t.integer  "max_heartbeat_interval", default: 180
    t.index ["user_id"], name: "index_apps_on_user_id", using: :btree
  end

  create_table "builds", force: :cascade do |t|
    t.integer  "app_id"
    t.string   "status"
    t.text     "log"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.binary   "source_file"
    t.index ["app_id"], name: "index_builds_on_app_id", using: :btree
  end

  create_table "deployments", force: :cascade do |t|
    t.integer  "app_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "tag"
    t.string   "board"
    t.binary   "image"
    t.string   "comment"
    t.integer  "major_version"
    t.integer  "minor_version"
    t.datetime "released_at"
    t.integer  "build_id"
    t.index ["app_id"], name: "index_deployments_on_app_id", using: :btree
    t.index ["build_id"], name: "index_deployments_on_build_id", using: :btree
    t.index ["major_version"], name: "index_deployments_on_major_version", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "board"
    t.integer  "user_id"
    t.string   "tag"
    t.string   "device_secret"
    t.integer  "app_id"
    t.string   "status"
    t.datetime "heartbeated_at"
    t.index ["app_id"], name: "index_devices_on_app_id", using: :btree
    t.index ["device_secret"], name: "index_devices_on_device_secret", using: :btree
    t.index ["user_id"], name: "index_devices_on_user_id", using: :btree
  end

  create_table "envvars", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_envvars_on_device_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "apps", "users"
  add_foreign_key "builds", "apps"
  add_foreign_key "deployments", "apps"
  add_foreign_key "deployments", "builds"
  add_foreign_key "devices", "apps"
  add_foreign_key "devices", "users"
  add_foreign_key "envvars", "devices"
end
