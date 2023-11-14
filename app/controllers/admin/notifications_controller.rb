class Admin::NotificationsController < ApplicationController

  load_and_authorize_resource
  respond_to :html
  def index
    @title = "Notifications"
  end
end
