# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :trades
  has_many :dividends
end
