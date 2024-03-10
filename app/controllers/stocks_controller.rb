# frozen_string_literal: true

class StocksController < ApplicationController
  def index
    @stocks = Stock.all.order(:ticker)
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    return unless @stock.save

    redirect_to stocks_path
  end

  private

  def stock_params
    params.require(:stock).permit(:ticker, :currency)
  end
end
