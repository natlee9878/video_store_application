class Admin::StocksController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    if params[:video_id].present?
      @video = Video.find_by(id: params[:video_id])

      if @video
        # Get stocks for this specific video only
        @stocks = @video.stocks
        puts "====================================Video ID: =======================================#{params[:video_id]}"
      else
        # Handle the case where the video is not found
        flash[:alert] = "Video not found"
        redirect_to admin_videos_path and return # Change `some_admin_path` to wherever you want to redirect in case of an error.
      end

    else
      # If video_id is not provided, get all stocks (this logic can be changed based on your requirements)
      @stocks = Stock.all
      puts "=======================Stock present==========================="
    end


    @title = 'Index'
    @stocks = apply_scopes(@stocks)
    @stocks = @stocks.active_status(params[:active]) if params[:active].present?

    respond_with(@stocks) do |format|
      format.html do
        #@actors = @actors.page(params[:page]).per(@default_limit)
        # index html group content starts here
        # index html group content ends here
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
      #format.js do
      # @actors = @actors.page(params[:page]).per(@default_limit)
      # render 'index.js.erb'
      #end
    end
  end

  def new
    @stock = Stock.new
    @title = "New Stock"
  end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      # Redirect to the stocks index page or show page
      redirect_to admin_stocks_path, notice: 'Stock was successfully created.'
    else
      # Re-render the 'new' template if the stock wasn't saved
      render :new
    end
  end

  def edit
    @title = "Edit #{@stock.first_name} #{@stock.last_name} "
    @alt_list = params[:alt_list]
    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'form'
    else
      render partial: 'quick_edit_form'
    end  end

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
    params.require(:stock).permit(:video_id,:format_type, :number_owned, :on_hand, :active)
  end
end
