# frozen_string_literal: true

class Dividend < ApplicationRecord
  belongs_to :account
  belongs_to :stock

  scope :for_stock_in_account, ->(stock, account) { where(stock:, account:) }
  scope :total_value_by_account, ->(account) { where(account:).sum(:amount) }
end
