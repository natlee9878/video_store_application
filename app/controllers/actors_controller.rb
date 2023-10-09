class ActorsController < ApplicationController
  def edit
    @actor = Actor.find(params[:id])
    @videos = @actor.videos
  end
end
