class InitSchema < ActiveRecord::Migration[5.0]
  def up
    
    create_table "apps", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
      t.integer  "user_id"
      t.integer  "max_heartbeat_interval", default: 180
      t.index ["user_id"], name: "index_apps_on_user_id"
    end
    
    create_table "deployments", force: :cascade do |t|
      t.integer  "app_id"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.string   "tag"
      t.string   "board"
      t.binary   "image",       limit: 33554432
      t.string   "comment"
      t.datetime "released_at"
      t.integer  "build_id"
      t.binary   "source_file"
      t.text     "buildlog"
      t.string   "status"
      t.integer  "version"
      t.index ["app_id"], name: "index_deployments_on_app_id"
      t.index ["build_id"], name: "index_deployments_on_build_id"
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
      t.index ["app_id"], name: "index_devices_on_app_id"
      t.index ["device_secret"], name: "index_devices_on_device_secret"
      t.index ["user_id"], name: "index_devices_on_user_id"
    end
    
    create_table "envvars", force: :cascade do |t|
      t.string   "name"
      t.string   "value"
      t.integer  "device_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["device_id"], name: "index_envvars_on_device_id"
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
      t.index ["email"], name: "index_users_on_email"
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    end
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
