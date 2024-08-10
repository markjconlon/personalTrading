# frozen_string_literal: true

class YahooPriceScraper
  BASE_URL = "https://finance.yahoo.com/quote/"
  CAD_BASE_URL = "https://ca.finance.yahoo.com/quote/"

  def initialize(stock:)
    puts "Working on #{stock.ticker}"
    @stock = stock
    @agent = Mechanize.new
  end

  def update_market_data
    begin
      page
    rescue StandardError => e
      puts e.message
      @page = "404"
    end

    @stock.live_price = price unless page == "404"
    @stock.live_price_as_of = Time.zone.now unless page == "404"
    @stock.save!
  end

  def live_price_symbol
    return @stock.live_price_symbol unless @stock.live_price_symbol.nil?

    @stock.live_price_symbol = @stock.ticker unless cad?
    @stock.live_price_symbol = "#{@stock.ticker}.TO" if cad?

    @stock.live_price_symbol
  end

  def cad?
    @cad ||= @stock.currency == "CAD"
  end

  def page
    @page ||= main_page || cad_page
  end

  def main_page
    @agent.get(BASE_URL + "#{live_price_symbol}/")
  rescue StandardError
    nil
  end

  def cad_page
    @agent.get(CAD_BASE_URL + "#{live_price_symbol}/")
  end

  def data_symbol_nodes
    @data_symbol_nodes ||= page.search('[data-symbol="' + live_price_symbol + '"]')
  end

  def price
    @price ||= data_symbol_nodes.find do |t|
      t.get_attribute("data-field") == "regularMarketPrice"
    end.inner_text.to_f * 100
  end
end
