class PagesController < ApplicationController
  def welcome
    @videos = Video.all # start with all videos
    # Filter by search query
    if params[:query].present?
      @videos = @videos.where("title LIKE ?", "%#{params[:query]}%")
    end
    # Filter by genre
    if params[:genre].present?
      @videos = @videos.joins(:genres).where(genres: { name: params[:genre] })
    end
    # Filter by content rating
    if params[:content_rating].present?
      @videos = @videos.where(content_rating: params[:content_rating])
    end
    # Filter by average rating (assuming you have a method or column for average rating)
    if params[:avg_rating].present?
      @videos = @videos.where("avg_rating >= ?", params[:avg_rating])
    end
  end

end
