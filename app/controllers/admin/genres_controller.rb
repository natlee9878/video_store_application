class Admin::GenresController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    @title= 'Genres'

    @genres = apply_scopes(@genres)
    @genres = @genres.search_by_name(params[:query]) if params[:query].present?
    @genres = @genres.active_status(params[:active]) if params[:active].present?

    respond_with(@genres) do |format|
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
    @title = "Edit #{@genre.name} "
    @alt_list = params[:alt_list]
    return unless request.xhr?
      render partial: 'quick_edit_form'
  end

  def new
    @genre = Genre.new
    @title = "New Genre "
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genrelist_path, notice: 'Genre was successfully created.'
    else
      render :new
    end
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_back(fallback_location: root_path, notice: 'Genre was successfully updated.')
    else
      render :edit
    end
  end

  private
  def genre_params
    params.require(:genre).permit(:name, :active)
  end
end
