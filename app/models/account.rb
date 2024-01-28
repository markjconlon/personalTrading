class Account < ApplicationRecord
    belongs_to :owner
    has_many :trades
    has_many :transactions
    has_many :dividends
end