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

ActiveRecord::Schema.define(version: 2020_05_16_202955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "chat_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "user_id"
    t.text "text"
    t.bigint "conversation_id"
    t.bigint "session_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_chat_messages_on_conversation_id"
    t.index ["session_id"], name: "index_chat_messages_on_session_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "chat_sessions", force: :cascade do |t|
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_chat_sessions_on_conversation_id"
    t.index ["user_id"], name: "index_chat_sessions_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.integer "player_1_id"
    t.integer "player_2_id"
    t.string "current_status"
    t.string "current_user"
    t.integer "result"
    t.integer "turn_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "firebase_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "moves", force: :cascade do |t|
    t.integer "game_id"
    t.string "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.string "color"
    t.boolean "mortgaged", default: false
    t.integer "cost", default: 0
    t.integer "mortgage_cost", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", default: 0
    t.integer "div_id", default: 0
    t.string "property_type", default: "regular"
    t.integer "houses", default: 0
    t.integer "hotels", default: 0
  end

  create_table "user_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.integer "position", default: 0
    t.integer "previous_position", default: 0
    t.integer "num_moves", default: 0
    t.integer "balance", default: 30
    t.string "piece", default: "car_piece.png"
    t.boolean "jail", default: false
    t.integer "last_roll", default: [], array: true
    t.boolean "show_roll", default: true
    t.boolean "show_buttons", default: false
    t.integer "num_double_rolls", default: 0
    t.integer "num_jail_escape_rolls", default: 0
    t.boolean "can_get_out_of_jail_free", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chat_status", default: "offline"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
