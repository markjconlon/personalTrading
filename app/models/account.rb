class Account < ApplicationRecord
  belongs_to :owner
  has_many :trades
  has_many :buys, -> { where type: "Buy" }, class_name: "Trade"
  has_many :sells, -> { where type: "Sell" }, class_name: "Trade"
  has_many :deposits, -> { where type: "Deposit" }, class_name: "Transaction"
  has_many :withdrawals, -> { where type: "Withdrawal" }, class_name: "Transaction"
  has_many :dividends
  has_many :stocks, through: :trades

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
    sells.group_by(&:stock).transform_values do |sells|
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
    sold_positions_hash = sold_positions
    bought_positions.map do |stock, value|
      sold_position = sold_positions[stock]
      sold_shares = sold_position.nil? ? 0 : sold_position[:shares]
      net_shares = value[:shares] - sold_shares
      price = value[:price]
      sold_price = (sold_position.nil? ? "-" : sold_position[:price])
      total_dividends = stock.dividends.total_value_by_account(self)
      {
        stock:,
        ticker: stock.ticker,
        shares: net_shares,
        price: money_formatter(price),
        book_value: money_formatter(net_shares * value[:price]),
        sold_shares:,
        sold_price: money_formatter(sold_price),
        total_dividends: money_formatter(total_dividends),
        closed_position_p_n_l: money_formatter(net_shares.zero? ? ((sold_price - price) * sold_shares + total_dividends) : "-")
      }
    end
  end

  def sorted_all_postions(key)
    all_positions.sort_by { |p| p[key] }
  end

  def money_formatter(value)
    return value unless value.is_a? Integer

    "$#{value.to_f / 100}"
  end
end
