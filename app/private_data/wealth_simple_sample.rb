# frozen_string_literal: true

class WealthSimpleSample
  def self.transactions
    # deposit and withdrawal filter on
  end

  def self.dividends
    # dividend filter on
  end

  def self.trades
    # buys and sells on
  end

  def self.trade_details
    # buys and sells on
  end

  def self.massage(method)
    send(method).map do |item|
      item.gsub("\n", ";;").gsub(" | ", ";;").gsub("$", ";;").split(";;")
    end
  end

  def self.massage_trades
    raise StandardError unless trades.count == trade_details.count

    data = []
    trades.map.with_index do |item, index|
      next if item.include?("Cancelled") || item.include?("Expired")

      arr = item.gsub("\n", ";;").gsub(" | ", ";;").gsub("$", ";;").split(";;")
      details = trade_details[index]

      next if details.include?("Cancelled") || item.include?("Expired")

      subbed_details = details.gsub("Filled", ";;").gsub("Quantity", ";;").gsub("Total amount", ";;").gsub(" x $",
                                                                                                           ";;").split(";;")

      data << {
        ticker: arr[0].split(" ").first,
        type: arr[0].downcase.include?("buy") ? "Buy" : "Sell",
        datetime: subbed_details[1].to_datetime,
        price: subbed_details[3],
        shares: subbed_details[2].split(" ").first
      }
    end
    data
  end
end
