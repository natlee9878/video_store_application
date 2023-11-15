class AdminController < ApplicationController
  before_action :ensure_admin

  private
  def ensure_admin
    unless current_user&.admin?
      flash[:alert] = "Unauthorized access!"
      redirect_to root_path
    end
  end
end