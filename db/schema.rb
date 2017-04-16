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

ActiveRecord::Schema.define(version: 20170414210336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agent_rooms", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_agent_rooms_on_user_id", using: :btree
  end

  create_table "agents", force: :cascade do |t|
    t.string  "name"
    t.integer "agent_room_id"
    t.boolean "has_greetings", default: false
    t.boolean "has_actions",   default: false
    t.boolean "has_beds",      default: false
    t.boolean "has_baths",     default: false
    t.boolean "has_min_price", default: false
    t.boolean "has_max_price", default: false
    t.boolean "has_address",   default: false
    t.boolean "has_general",   default: false
    t.string  "greetings"
    t.string  "actions"
    t.string  "beds"
    t.string  "baths"
    t.integer "min_price"
    t.integer "max_price"
    t.jsonb   "address",       default: {},    null: false
    t.jsonb   "data",          default: {},    null: false
    t.index ["agent_room_id"], name: "index_agents_on_agent_room_id", using: :btree
  end

  create_table "listings", force: :cascade do |t|
    t.integer  "sysid"
    t.integer  "listing_id"
    t.string   "property_type"
    t.string   "property_tax"
    t.integer  "price"
    t.integer  "original_list_price"
    t.integer  "living_area"
    t.integer  "beds"
    t.integer  "baths"
    t.integer  "half_baths"
    t.boolean  "garage",              default: false
    t.text     "description"
    t.string   "state"
    t.string   "city"
    t.string   "street"
    t.string   "full_street"
    t.string   "photo"
    t.string   "year_built"
    t.integer  "source",              default: 0
    t.string   "url"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "agent_room_id"
    t.integer  "agent_id"
    t.integer  "sender_type",   default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["agent_id"], name: "index_messages_on_agent_id", using: :btree
    t.index ["agent_room_id"], name: "index_messages_on_agent_room_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string "city"
    t.string "state_short"
    t.string "state_full"
    t.string "alias"
    t.string "county"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "agent_rooms", "users"
end
