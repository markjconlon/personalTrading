# frozen_string_literal: true

class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  def show
    @account = Account
               .includes(:deposits, :withdrawals, dividends: :stock, trades: :stock)
               .find(params[:id])

    @positions = positions
    @current_positions = positions.select { |p| p[:shares].positive? }
    @closed_positions = positions.reject { |p| p[:shares].positive? }
    @current_value = @current_positions.map { |p| p[:current_value] }.reject { |v| v == "-" }.sum
    @last_dividends = @account.dividends.order(datetime: :desc).first(50)
    @trades = @account.trades.order(datetime: :desc)
    @first_deposit_date = @account.deposits.order(:datetime).first
  end

  def positions
    direction = params.dig(:sort, :direction)&.to_sym || :asc
    column = params.dig(:sort, :column)&.to_sym || :ticker
    @account.sorted_all_postions(direction:, column:)
  end

  def import_activity
    return redirect_to request.referer, notice: "No file added" if params[:file].nil?
    return redirect_to request.referer, notice: "Only CSV files allowed" unless params[:file].content_type == "text/csv"

    CsvImportActivityService.new.call(params[:file], import_account)

    redirect_to request.referer, notice: "Import started..."
  end

  private

  def import_account
    Account.find(params[:account_id])
  end
end
