# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :trades
  has_many :dividends

  def self.fresh_market_data
    all.each do |stock|
      YahooPriceScraper.new(stock:).update_market_data
    end
  end
end
