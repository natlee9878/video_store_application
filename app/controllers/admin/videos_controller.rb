class Admin::VideosController < ApplicationController
    before_action :set_video, only: %i[edit update]
    load_and_authorize_resource
    respond_to :html
    skip_authorization_check only: %i[cleanup_dropzone_upload destroy_uploads]

    def index
      @is_portlet = params[:portlet].present?

      if params[:actor_id].present?
        # When video_id is provided, fetch actors associated with the specific video.
        @actor = Actor.find(params[:actor_id])
        @videos = @actor.videos
      else
        # Regular path, listing all actors (or whatever your standard operation is).
        @videos = Video.all
      end
      @title = 'Videos'

      @videos = apply_scopes(@videos)
      @videos = @videos.search_by_title(params[:query]) if params[:query].present?
      @videos = @videos.active_status(params[:active]) if params[:active].present?

      respond_with(@videos) do |format|
        format.html do
          if params[:commit] == 'Clear'
            redirect_back(fallback_location: root_path)
          elsif request.xhr?
            render partial: 'table'
          end
        end
      end
    end
    def new
      @video = Video.new
      @title = "New Video"
    end
    def create
      @Video = Video.new
      if @video.save
        # Redirect to the show or index page with a success message
        redirect_to admin_video_path(@video), notice: 'Video was successfully created.'
      else
        render :new
      end
    end
    # Deletes dropzone uploads
    def cleanup_dropzone_upload
      associated_class = params['attribute_param'].scan(/\[(.*)\]/).flatten.first.gsub('_attributes', '')

      records =
        params['class_name'].titleize.tr(' ', '').constantize
                            .find_by(id: params['record_id'])
                            .send(associated_class)
                            .map do |a|
          next unless a.file.identifier ==
            (
              params['record_name'].gsub(' ', '_') &&
                a.created_at.to_date == Date.current
            )

          { id: a.id, name: a.file.identifier }
        end
      records = records.reject(&:nil?)

      success = Attachment.find(records.last[:id]).destroy
      render json: { success: }
    end

    def edit
      @title = "Edit #{@video.title} "
      @alt_list = params[:alt_list]
      return unless request.xhr?

      if params[:single_show_edit]
        render partial: 'form'
      else
        render partial: 'quick_edit_form'
      end
    end
    # def edit
    #   @video = Video.find(params[:id])
    #   @video_stocks = Stock.where(videos_id: @video.id)
    #   # Fetch actors associated with the video using the actor_videos association.
    #   actor_ids = ActorVideo.where(video_id: @video.id).pluck(:actor_id)
    #   @video_actors = Actor.where(id: actor_ids)
    #   @actor_videos = ActorVideo.where(video_id: @video.id)
    # end
    def fields
      @video = Video.find(params[:id])
      @video_actors = @video.actors
      @video_stocks= @video.stocks
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

    def set_video
      @video = Video.find(params[:id])
    end
end