class AdminController < ApplicationController
  before_action :ensure_admin

  def dashboard
    @users = User.all
    @videos = Video.all
  end

  def genrelist
    @genres=Genre.all
  end

  def actorlist
    @actors = Actor.all
  end

  def admin_dashboard_users
    if params[:query].present?
      query = "%#{params[:query]}%"
      @users = User.where("email LIKE ?", query)

      # Filtering videos by title and description
      @videos = Video.where("title LIKE ? OR description LIKE ?", query, query)
    else
      @users = User.all
      @videos = Video.all
    end
    # Your authorization logic here, if any
  end

  private

  def ensure_admin
    unless current_user&.admin?
      flash[:alert] = "Unauthorized access!"
      redirect_to root_path
    end
  end
end