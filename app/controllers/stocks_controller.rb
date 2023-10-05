class StocksController < ApplicationController
  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])
    if @stock.update(stock_params)
      redirect_back(fallback_location: root_path, notice: 'Stock was successfully updated.')
    else
      render :edit
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:format_type, :number_owned, :on_hand, :active)
  end
end
