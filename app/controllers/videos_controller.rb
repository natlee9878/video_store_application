class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to @video, notice: 'Video was successfully created.'
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:thumbnail, :title, :genre, :content_rating, :avg_rating)
  end
end
