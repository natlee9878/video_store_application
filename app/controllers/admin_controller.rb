class AdminController < ApplicationController
  before_action :ensure_admin_or_super_user

  private
  def ensure_admin_or_super_user
    unless current_user&.admin? || current_user&.super_user?
      flash[:alert] = "Unauthorized access!"
      redirect_to root_path
    end
  end
end