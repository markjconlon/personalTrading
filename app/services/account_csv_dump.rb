# frozen_string_literal: true

# rubocop:disable Metrics
# takes an account which puts account activity into CSV
class AccountCsvDump
  require "csv"
  HEADERS = %w[Class Date Ticker Amount Shares Price Currency].freeze
  attr_reader :rows, :csv

  def initialize(account:)
    @account = Account
               .includes(:trades, :transactions, :dividends, :conversions, :stocks)
               .find(account.id)
    @rows = [HEADERS]
  end

  def call
    dump_trades
    dump_transactions
    dump_dividends
    dump_conversions
    make_csv
  end

  def dump_trades
    @account.trades.order(:datetime).each do |trade|
      @rows << [
        trade.class.name,
        trade.datetime.to_date,
        trade.stock.ticker,
        "-",
        trade.shares,
        trade.price,
        "-"
      ]
    end
  end

  def dump_transactions
    @account.transactions.order(:datetime).each do |trade|
      @rows << [
        trade.class.name,
        trade.datetime.to_date,
        "-",
        trade.amount,
        "-",
        "-",
        trade.currency
      ]
    end
  end

  def dump_dividends
    @account.dividends.order(:datetime).each do |trade|
      @rows << [
        trade.class.name,
        trade.datetime.to_date,
        trade.stock.ticker,
        trade.amount,
        "-",
        "-",
        trade.currency
      ]
    end
  end

  def dump_conversions; end

  def make_csv
    ::CSV.open("account_dump#{Time.zone.now}.csv", "w") do |csv|
      rows.each { |row| csv << row }
    end
  end
end
# rubocop:enable Metrics
