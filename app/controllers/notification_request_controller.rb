class Admin::NotificationRequestController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    @notification_request = apply_scopes(@notification_request)
    @notification_request = @notification_request.search_by_name(params[:query]) if params[:query].present?
    @notification_request = @notification_request.active_status(params[:active]) if params[:active].present?

    respond_with(@notification_request) do |format|
      format.html do
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
    end
  end


end
