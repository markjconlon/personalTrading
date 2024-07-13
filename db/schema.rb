# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_13_002200) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_accounts_on_name"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "conversions", force: :cascade do |t|
    t.integer "amount_in", null: false
    t.integer "amount_out", null: false
    t.datetime "datetime", null: false
    t.string "currency_in", null: false
    t.string "currency_out", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_conversions_on_account_id"
    t.index ["currency_in"], name: "index_conversions_on_currency_in"
    t.index ["currency_out"], name: "index_conversions_on_currency_out"
    t.index ["datetime"], name: "index_conversions_on_datetime"
  end

  create_table "dividends", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "datetime", null: false
    t.string "currency", null: false
    t.integer "account_id"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_dividends_on_account_id"
    t.index ["currency"], name: "index_dividends_on_currency"
    t.index ["datetime"], name: "index_dividends_on_datetime"
    t.index ["stock_id"], name: "index_dividends_on_stock_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker", null: false
    t.string "currency", null: false
    t.string "live_price_symbol"
    t.integer "live_price"
    t.datetime "live_price_as_of"
    t.index ["currency"], name: "index_stocks_on_currency"
    t.index ["ticker"], name: "index_stocks_on_ticker", unique: true
  end

  create_table "trades", force: :cascade do |t|
    t.string "type", null: false
    t.integer "shares", null: false
    t.integer "price", null: false
    t.datetime "datetime", null: false
    t.integer "account_id"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_trades_on_account_id"
    t.index ["datetime"], name: "index_trades_on_datetime"
    t.index ["stock_id"], name: "index_trades_on_stock_id"
    t.index ["type"], name: "index_trades_on_type"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "datetime", null: false
    t.string "type", null: false
    t.string "currency", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["currency"], name: "index_transactions_on_currency"
    t.index ["datetime"], name: "index_transactions_on_datetime"
    t.index ["type"], name: "index_transactions_on_type"
  end

end
