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

ActiveRecord::Schema.define(version: 20150403203008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "hstore"

  create_table "authorizations", force: :cascade do |t|
    t.text     "username"
    t.text     "provider"
    t.text     "uid"
    t.text     "token"
    t.text     "secret"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "name",       default: "Team Board", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
    t.text     "public_id",                         null: false
  end

  add_index "boards", ["public_id"], name: "index_boards_on_public_id", unique: true, using: :btree
  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree

  create_table "jobs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "jobId",                       null: false
    t.text     "settings",       default: ""
    t.text     "widgetSettings", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "board_id",                    null: false
    t.datetime "last_run_at"
    t.datetime "next_run_at"
    t.text     "last_data"
  end

  add_index "jobs", ["next_run_at"], name: "index_jobs_on_next_run_at", using: :btree

  create_table "teams", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "name",       default: "Team", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "email",                                   null: false
    t.text     "full_name",              default: "",     null: false
    t.text     "calling_name",           default: "",     null: false
    t.text     "picture",                default: "",     null: false
    t.boolean  "male"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "encrypted_password",     default: ""
    t.text     "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text     "current_sign_in_ip"
    t.text     "last_sign_in_ip"
    t.text     "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "unconfirmed_email"
    t.text     "provider"
    t.text     "uid"
    t.text     "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.uuid     "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.uuid     "team_id"
    t.text     "type",                   default: "User", null: false
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

end
