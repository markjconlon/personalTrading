# frozen_string_literal: true

class PopulateLivePrice
  KNOWN_TICKERS = {
    "SCHD" => "SCHD",
    "VTI" => "VTI",
    "XAW" => "XAW.TO",
    "VDY" => "VDY.TO",
    "AQN" => "AQN.TO",
    "ATD" => "ATD.TO",
    "EIT-UN" => "EIT-UN.TO",
    "ETHY" => "ETHY.TO",
    "GDV" => "GDV.TO",
    "HDIF" => "HDIF.TO",
    "HDIV" => "HDIV.TO",
    "HYLD" => "HYLD.TO",
    "LBS" => "LBS.TO",
    "PSA" => "PSA.TO",
    "RS" => "RS.TO",
    "VFV" => "VFV.TO",
    "XEI" => "XEI.TO",
    "CASH" => "CASH.TO",
    "T" => "T.TO",
    "TD" => "TD.TO",
    "TSLA" => "TSLA.TO",
    "SHOP" => "SHOP.TO"
  }.freeze

  def call
    Stock.all.each do |stock|
      symbol = KNOWN_TICKERS[stock.ticker.to_s]
      next unless symbol

      price = live_price(symbol)
      next unless price

      stock.update!(
        live_price_symbol: symbol,
        live_price: (price.to_f * 100).round,
        live_price_as_of: Time.zone.now
      )
    end
  end

  def live_price(symbol)
    api_key = Rails.application.credentials[:live_price_key]
    uri = URI("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{symbol}&apikey=#{api_key}")
    JSON.parse(Net::HTTP.get(uri)).dig("Global Quote", "05. price")
  end
end
