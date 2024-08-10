# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :owner
  has_many :trades
  has_many :drips, -> { where type: "Drip" }, class_name: "Trade"
  has_many :buys, -> { where type: %w[Buy Drip] }, class_name: "Trade"
  has_many :sells, -> { where type: "Sell" }, class_name: "Trade"
  has_many :transactions
  has_many :deposits, -> { where type: "Deposit" }, class_name: "Transaction"
  has_many :withdrawals, -> { where type: "Withdrawal" }, class_name: "Transaction"
  has_many :dividends
  has_many :stocks, through: :trades
  has_many :conversions

  def bought_positions
    buys.group_by(&:stock).transform_values do |buys|
      bought_shares = buys.sum(&:shares)
      average_price = buys.sum do |trade|
        trade.shares * trade.price
      end / bought_shares
      {
        shares: bought_shares,
        price: average_price
      }
    end
  end

  def sold_positions
    @sold_positions ||= sells.group_by(&:stock).transform_values do |sells|
      sold_shares = sells.sum(&:shares)
      average_price = sells.sum do |trade|
        trade.shares * trade.price
      end / sold_shares
      {
        shares: sold_shares,
        price: average_price
      }
    end
  end

  def all_positions
    bought_positions.map do |stock, value|
      sold_position = sold_positions[stock]
      sold_shares = sold_position.nil? ? 0 : sold_position[:shares]
      net_shares = value[:shares] - sold_shares
      price = value[:price]
      sold_price = (sold_position.nil? ? "-" : sold_position[:price])
      total_dividends = stock.dividends.total_value_by_account(self)
      live_price = stock.live_price
      current_value = live_price ? net_shares * live_price : 0
      book_value = net_shares * value[:price]
      {
        stock:,
        ticker: stock.ticker,
        shares: net_shares,
        price: price.to_f / 100,
        current_price: live_price ? live_price.to_f / 100 : "-",
        book_value: book_value.to_f / 100,
        current_value: live_price ? (net_shares * live_price).to_f / 100 : "-",
        sold_shares:,
        sold_price: sold_price.to_f / 100,
        total_dividends: total_dividends.to_f / 100,
        closed_position_p_n_l: net_shares.zero? ? ((sold_price - price) * sold_shares + total_dividends).to_f / 100 : "-",
        live_p_n_l: (current_value - book_value + total_dividends).to_f / 100
      }
    end
  end

  def sorted_all_postions(direction:, column:)
    sorted = all_positions.sort_by { |p| p[column] }
    return sorted if direction == :asc

    sorted.reverse
  end

  def money_formatter(value)
    return value unless value.is_a? Integer

    "$#{value.to_f / 100}"
  end

  def total_dividends
    @total_dividends ||= dividends.sum(:amount)
  end

  def total_dividends_dollars
    total_dividends.to_f / 100
  end

  def sum_deposits
    @sum_deposits ||= deposits.sum(:amount)
  end

  def sum_deposits_dollars
    sum_deposits.to_f / 100
  end

  def sum_withdrawals
    @sum_withdrawals ||= withdrawals.sum(:amount)
  end

  def sum_withdrawals_dollars
    sum_withdrawals.to_f / 100
  end

  def net_deposits
    @net_deposits ||= sum_deposits - sum_withdrawals
  end

  def net_deposits_dollars
    net_deposits.to_f / 100
  end

  def snowball_percentage
    @snowball_percentage ||= ((total_dividends / net_deposits.to_f) * 100).round(4)
  end
end
