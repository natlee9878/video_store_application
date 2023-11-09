class ActorVideosController < ApplicationController
  def edit
    @actor_video = ActorVideo.find(params[:id])
    @video = @actor_video.video
    @actors = Actor.all
  end

  def update
    @actor_video = ActorVideo.find(params[:actor_video_id])
    if @actor_video.update(actor_video_params)
      redirect_to edit_video_path(@actor_video.video), notice: 'Actor was successfully updated for the video.'
    else
      render :edit
    end
  end

  def destroy
    @actor_video = ActorVideo.find(params[:id])
    @video = @actor_video.video
    @actor_video.destroy
    redirect_to edit_video_path(@video), notice: 'Actor was successfully removed from the video.'
  end

  private
  def actor_video_params
    params.require(:actor_video).permit(:actor_id)
  end
end
