class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  def show
    @account = Account
               .includes(:deposits, :withdrawals, trades: :stock)
               .find(params[:id])

    @positions = @account.sorted_all_postions(:ticker)
    sum_deposits = @account.deposits.sum(:amount)
    sum_withdrawals = @account.withdrawals.sum(:amount)
    total_dividends = (@positions.reduce(0) { |sum, value| sum + value[:total_dividends].gsub("$", "").to_f }).round(4)
    @net_deposits = money_formatter(sum_deposits - sum_withdrawals)
    @total_dividends = money_formatter(total_dividends)
    @snowball_percentage = "#{((total_dividends.to_f * 100 / (sum_deposits - sum_withdrawals).to_f) * 100).round(4)}%"
  end

  def money_formatter(value)
    return value unless value.is_a? Integer || value.is_a?(Float)

    "$#{value.to_f / 100}"
  end
end
