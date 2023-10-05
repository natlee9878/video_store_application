class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def edit
    @video = Video.find(params[:id])
    @video_stocks = Stock.where(videos_id: @video.id)
  end
  def index
    @videos = Video.all # start with all videos
    # Filter by search query
    if params[:query].present?
      @videos = @videos.where("title LIKE ?", "%#{params[:query]}%")
    end
    # Filter by genre
    if params[:genre].present?
      @videos = @videos.where(genre: params[:genre])
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
  def show
    @video = Video.find(params[:id])
  end
  def search
    if params[:query].present?
      query = "%#{params[:query]}%"
      @videos = Video.where("title LIKE ? OR description LIKE ?", query, query)
    else
      @videos = Video.all
    end
    render :index
  end
  def update
    @video = Video.find(params[:id])
    if @video.update(video_params)
      redirect_to admin_dashboard_users_path, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :content_rating, :avg_rating, :thumbnail, genre_ids: [])
  end
end
