class Admin::RentalsController < ApplicationController
  before_action :set_video, only: %i[edit update]
  load_and_authorize_resource
  respond_to :html
  skip_authorization_check only: %i[cleanup_dropzone_upload destroy_uploads]
  def index
    @rentals = if params[:user_id]
                 Rental.where(user_id: params[:user_id])
               else
                 Rental.all # Or Rental.all, if you want to display all when no user_id is provided
               end
    @title = 'Rental'

    @rentals = apply_scopes(@rentals)
    @rentals = @rentals.returned_status(params[:returned]) if params[:returned].present?

    if params[:sort_order].present?
      @rentals = @rentals.order(order_date: params[:sort_order])
    end
    if params[:order_date].present?
      order_date = DateTime.parse(params[:order_date]).beginning_of_day
      @rentals = @rentals.where('order_date >= ?', order_date)
    end
    if params[:return_date].present?
      return_date = DateTime.parse(params[:return_date]).end_of_day
      @rentals = @rentals.where('order_date <= ?', return_date)
    end

    respond_with(@rentals) do |format|
      format.html do
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
    end
  end

  def new
    @rental = Rental.new
    @title = "New Rental"
  end

  def edit
    @title = "Edit #{@rental.first_name} #{@rental.last_name} "
    @alt_list = params[:alt_list]
    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'form'
    else
      render partial: 'quick_edit_form'
    end
  end

  def overdue_reminder

    @rental = Rental.where(user_id: @user.id).first # Adjust this query as needed
    puts "=================================================== Rental found: #{@rental.inspect} =================================================== "
    @user = @rental.user
  end

end