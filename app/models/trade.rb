class Trade < ApplicationRecord
    belongs_to :stock
    belongs_to :account
end