class WelcomeController < ApplicationController
  def index
    @videos = Video.all
    @videos = apply_scopes(@videos)
      @videos = @videos.search_by_title(params[:query]) if params[:query].present?
      @videos = @videos.active_status(params[:active]) if params[:active].present?
  end
end
