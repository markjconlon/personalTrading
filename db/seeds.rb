# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

ActiveRecord::Base.transaction do
    account_holders = [
        {
            firstname: "Mark",
            lastname: "Conlon",
            account_names: %w[ WealthSimpleTFSA TDTFSA TDRRSP CommonWealth]
        },
        {
            firstname: "Carolyn",
            lastname: "Conlon",
            account_names: %w[ WealthSimpleTFSA TDRRSP]
        },
    ]
    account_holders.each do |owner|
        ownerRec = Owner.find_or_create_by(owner.reject{|a| a == :account_names})
        owner[:account_names].each do |name|
            Account.find_or_create_by!(owner: ownerRec, name: name)
        end
    end
    mark = Owner.find_by(firstname: "Mark")
    mark_wealthsimple = mark.accounts.find_by(name: "WealthSimpleTFSA")
    mark_wealthsimple_trades = WealthSimple.massage_trades
    mark_wealthsimple_trades.map{|i| i[:ticker]}.uniq.each do |ticker|
        Stock.create(
            ticker: ticker,
            currency: "CAD"
        )
    end
    # see private_data/helpers.js and sample files to create real files
    mark_wealthsimple_trades.each do |trade|
        stock = Stock.find_by(ticker: trade[:ticker])
        Trade.create(
            type: trade[:type],
            stock: stock,
            account: mark_wealthsimple,
            datetime: trade[:datetime],
            price: trade[:price].to_d * 100,
            shares: trade[:shares]
        )
    end
    
    WealthSimple.massage(:transactions).each do |trans|
        Transaction.create(
            type: trans[0],
            datetime: trans[2].to_datetime,
            amount: trans[3].to_d * 100,
            account: mark_wealthsimple,
            currency: "CAD"
        )
    end
    
    WealthSimple.massage(:dividends).each do |trans|
        stock = Stock.find_by(ticker: trans[0].split(" ").first)
        Dividend.create(
            datetime: trans[2].to_datetime,
            amount: trans[3].to_d * 100,
            account: mark_wealthsimple,
            stock: stock,
            currency: "CAD"
        )
    end
end