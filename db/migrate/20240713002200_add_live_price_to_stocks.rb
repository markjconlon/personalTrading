class AddLivePriceToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :live_price_symbol, :string
    add_column :stocks, :live_price, :integer
    add_column :stocks, :live_price_as_of, :datetime
  end
end
