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

ActiveRecord::Schema.define(version: 20180131030436) do

  create_table "channels", force: :cascade do |t|
    t.string "keyword"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.string "symbol"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.text "full_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_exchange_rates_on_created_at"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "keyword"
    t.string "unique_id"
    t.text "full_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "channel_id"
    t.text "statistics_json"
    t.index ["channel_id", "created_at"], name: "index_tweets_on_channel_id_and_created_at"
    t.index ["channel_id"], name: "index_tweets_on_channel_id"
  end

end
