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

ActiveRecord::Schema.define(version: 20170308142036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "complement"
    t.string   "neighborhood"
    t.integer  "city_id"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "zip_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["city_id"], name: "index_addresses_on_city_id", using: :btree
    t.index ["country_id"], name: "index_addresses_on_country_id", using: :btree
    t.index ["state_id"], name: "index_addresses_on_state_id", using: :btree
  end

  create_table "ads", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "advertisers", force: :cascade do |t|
    t.integer  "document_type"
    t.string   "document_number"
    t.string   "email"
    t.string   "website"
    t.string   "facebook"
    t.string   "instagram"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "landline"
    t.string   "cell_phone"
    t.index ["user_id"], name: "index_advertisers_on_user_id", using: :btree
  end

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "ad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_areas_on_ad_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "description"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_guests", force: :cascade do |t|
    t.integer  "guest_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.index ["event_id"], name: "index_event_guests_on_event_id", using: :btree
    t.index ["guest_id", "event_id"], name: "index_event_guests_on_guest_id_and_event_id", unique: true, using: :btree
    t.index ["guest_id"], name: "index_event_guests_on_guest_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.date     "event_date"
    t.integer  "address_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.text     "about"
    t.index ["address_id"], name: "index_events_on_address_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "accepted"
    t.index ["group_id"], name: "index_group_members_on_group_id", using: :btree
    t.index ["user_id"], name: "index_group_members_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "about"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.index ["user_id"], name: "index_groups_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "uf"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "advertiser_id"
    t.integer  "ad_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ad_id"], name: "index_transactions_on_ad_id", using: :btree
    t.index ["advertiser_id"], name: "index_transactions_on_advertiser_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cellphone"
    t.date     "birthday"
    t.string   "sex"
    t.integer  "nautical_professional"
    t.text     "academic_profile"
    t.integer  "relationship"
    t.integer  "partner_id"
    t.text     "about"
    t.integer  "has_embarcation"
    t.text     "nautical_profession_description"
    t.text     "naval_service"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "email",                           default: "", null: false
    t.string   "encrypted_password",              default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["partner_id"], name: "index_users_on_partner_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "states"
  add_foreign_key "advertisers", "users"
  add_foreign_key "areas", "ads"
  add_foreign_key "cities", "states"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "event_guests", "events"
  add_foreign_key "event_guests", "users", column: "guest_id"
  add_foreign_key "events", "addresses"
  add_foreign_key "events", "users"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "states", "countries"
  add_foreign_key "transactions", "ads"
  add_foreign_key "transactions", "advertisers"
  add_foreign_key "users", "users", column: "partner_id"
end
