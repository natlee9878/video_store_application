class Admin::NotificationsController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    @title = "Notifications"

    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @notifications = Notification.joins(rentals_video: { rental: :user })
                                   .where(users: { id: params[:user_id] })
                                   .select('notifications.*') # Adjust as needed
    else
      # Handle the case where user_id is not provided
      @notifications = Notification.all # or handle differently as per your need
    end

    @notifications = apply_scopes(@notifications)
    @notifications = @notifications.active_status(params[:status]) if params[:status].present?

    respond_with(@notifications) do |format|
      format.html do
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
    end
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification.update(notification_params)
      redirect_back(fallback_location: root_path, notice: 'Notification was successfully updated.')
    else
      render :edit
    end
  end

  def edit
    @title = "Edit Notification #{@notification.id} "
    @alt_list = params[:alt_list]
    return unless request.xhr?
    render partial: 'quick_edit_form'
  end

  private
  def notification_params
    params.require(:notification).permit(:id, :status)
  end
end
