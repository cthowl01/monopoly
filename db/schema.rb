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

ActiveRecord::Schema.define(version: 2020_05_06_165402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "properties", force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.string "color"
    t.integer "holdfasts", default: 0
    t.integer "castles", default: 0
    t.boolean "mortgaged", default: false
    t.integer "cost", default: 0
    t.integer "mortgage_cost", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", default: 0
    t.integer "div_id", default: 0
    t.string "property_type", default: "regular"
  end

  create_table "user_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.integer "position", default: 0
    t.integer "previous_position", default: 0
    t.integer "num_moves", default: 0
    t.integer "balance", default: 30
    t.string "piece", default: "/assets/car_piece.png"
    t.boolean "jail", default: false
    t.integer "last_roll", default: [], array: true
    t.boolean "show_roll", default: true
    t.integer "num_double_rolls", default: 0
    t.integer "num_jail_escape_rolls", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
