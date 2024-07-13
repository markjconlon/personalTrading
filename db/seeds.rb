# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

ActiveRecord::Base.transaction do
    account_holders = [
        {
            firstname: "Mark",
            lastname: "Conlon",
            account_names: %w[ WealthSimpleTFSA TDTFSA TDRRSP GRPRSP ]
        }
    ]
    account_holders.each do |owner|
        ownerRec = Owner.find_or_create_by(owner.reject{|a| a == :account_names})
        owner[:account_names].each do |name|
            Account.find_or_create_by!(owner: ownerRec, name: name)
        end
    end
end
