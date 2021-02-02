# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_02_200357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feeds", force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_id"], name: "index_feeds_on_payment_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "first_friend_id", null: false
    t.bigint "second_friend_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_friend_id", "second_friend_id"], name: "index_friendships_on_first_friend_id_and_second_friend_id", unique: true
    t.index ["first_friend_id"], name: "index_friendships_on_first_friend_id"
    t.index ["second_friend_id"], name: "index_friendships_on_second_friend_id"
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "balance", default: 0.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_payment_accounts_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.float "amount", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_payments_on_receiver_id"
    t.index ["sender_id"], name: "index_payments_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "feeds", "payments"
  add_foreign_key "friendships", "users", column: "first_friend_id"
  add_foreign_key "friendships", "users", column: "second_friend_id"
  add_foreign_key "payment_accounts", "users"
  add_foreign_key "payments", "users", column: "receiver_id"
  add_foreign_key "payments", "users", column: "sender_id"
end
