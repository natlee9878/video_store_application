class AdminController < ApplicationController
  before_action :ensure_admin

  def videolist
    @videos = Video.all
    if params[:query].present?
      @videos = @videos.search_by_title(params[:query])
    end
    respond_to do |format|
      format.html
    end
  end
  def userlist
    # Starts with all users
    @users = User.all

    # Apply the filters based on the query parameter.
    if params[:query].present?
      @users = @users.search_by_name(params[:query])
    end

    # Respond to the request with the filtered users
    respond_to do |format|
      format.html
    end
    puts "===================================="
    puts "Debugging Information"
    puts "Query Parameter: #{params[:query]}"
    puts "Number of Users Loaded: #{@users.size}"
    @users.each do |user|
      puts "User Full Name: #{user.first_name} #{user.last_name}"
    end
    puts "===================================="
  end

  def rentallist
    @rentals=Rental.all
  end
  def genrelist
    @genres=Genre.all
  end


  def actorlist
    if params[:query].present?
      @actors = Actor.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
      puts '==== Filter Query ===='
      puts @actors.to_sql
      puts '======================'
      puts '==== Filtered Actors 1  ===='
      @actors.each do |actor|
        puts "Name: #{actor.first_name} #{actor.last_name}, Active: #{actor.active}"
      end
      puts '========================='
    else
      @actors = Actor.all
      puts '==== Filtered Actors 2 ===='
      @actors.each do |actor|
        puts "Name: #{actor.first_name} #{actor.last_name}, Active: #{actor.active}"
      end
      puts '========================='
    end

    respond_to do |format|
      format.html
      format.js  # Add this line to handle JS requests.
    end
  end


  def admin_dashboard_users
    if params[:query].present?
      query = "%#{params[:query]}%"
      @users = User.where("email LIKE ?", query)

      @videos = Video.where("title LIKE ? OR description LIKE ?", query, query)
    else
      @users = User.all
      @videos = Video.all
    end
  end

  private

  def ensure_admin
    unless current_user&.admin?
      flash[:alert] = "Unauthorized access!"
      redirect_to root_path
    end
  end


end