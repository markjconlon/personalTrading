# frozen_string_literal: true

class CsvImportActivityService
  require "csv"

  def call(file, account)
    @account = account
    opened_file = File.open(file)
    options = { headers: true, col_sep: "," }
    ActiveRecord::Base.transaction do
      CSV.foreach(opened_file, **options) do |row|
        case row["Class"]
        when "Buy"
          trade(row)
        when "Sell"
          trade(row)
        when "Drip"
          trade(row)
        when "Deposit"
          transaction(row)
        when "Withdrawal"
          transaction(row)
        when "Interest"
          transaction(row)
        when "Conversion"
          conversion(row)
        when "Dividend"
          dividend(row)
        end
      end
    end
  end

  def trade(row)
    stock = Stock.find_or_create_by(ticker: row["Ticker"], currency: row["Currency"])
    Trade.create!(
      account: @account,
      stock:,
      type: row["Class"],
      datetime: row["Date"].to_datetime,
      price: row["Price"],
      shares: row["Shares"]
    )
  end

  def transaction(row)
    Transaction.create!(
      account: @account,
      type: row["Class"],
      datetime: row["Date"].to_datetime,
      amount: row["Amount"],
      currency: row["Currency"]
    )
  end

  def dividend(row)
    stock = Stock.find_or_create_by(ticker: row["Ticker"], currency: row["Currency"])
    Dividend.create!(
      account: @account,
      stock:,
      amount: row["Amount"],
      currency: row["Currency"],
      datetime: row["Date"].to_datetime
    )
  end

  def conversion(row)
    Conversion.create!(
      amount_in: row["Amount"],
      amount_out: row["Price"],
      account: @account,
      currency_in: row["Currency"] == "CAD" ? "USD" : "CAD",
      currency_out: row["Currency"],
      datetime: row["Date"].to_datetime
    )
  end
end
