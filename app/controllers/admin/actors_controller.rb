class Admin::ActorsController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    @is_portlet = params[:portlet].present?

    #TO FILTER FOR CHILD ACTORS TABLE
    if params[:video_id].present?
      # When video_id is provided, fetch actors associated with the specific video.
      @video = Video.find(params[:video_id])
      @actors = @video.actors
    else
      # Regular path, listing all actors (or whatever your standard operation is).
      @actors = Actor.all
    end
    @title = 'Actors'

    #PARENT ACTORS
    @actors = apply_scopes(@actors)
    @actors = @actors.search_by_name(params[:query]) if params[:query].present?
    @actors = @actors.active_status(params[:active]) if params[:active].present?

    respond_with(@actors) do |format|
      format.html do
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
    end
  end

  def edit
    @title = "Edit #{@actor.first_name} #{@actor.last_name} "
    @alt_list = params[:alt_list]
    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'form'
    else
      render partial: 'quick_edit_form'
    end
  end

  def new
    @actor = Actor.new
    @title = "New Actor"
  end

    private
    def actor_params
      params.permit(:first_name, :last_name, :birthdate, :gender_id)
    end

  end
