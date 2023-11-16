class PagesController < ApplicationController
  def welcome
    @videos = Video.all # or any other query to fetch videos
  end
end
