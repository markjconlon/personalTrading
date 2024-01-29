class Dividend < ApplicationRecord
    belongs_to :account
    belongs_to :stock

    scope :for_stock_in_account, -> (stock, account) { where(stock: stock, account: account)}
    scope :total_value_by_account, -> (account) { where(account: account).sum(:amount) }
end