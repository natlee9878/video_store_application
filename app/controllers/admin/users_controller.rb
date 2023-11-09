class Admin::UsersController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  def index
    @is_portlet = params[:portlet].present?

    if params[:user_id].present?
      # Filter rentals where the user_id matches the parameter passed
      @rentals = Rental.where(user_id: params[:user_id])
    else
      # If no user_id is passed, you might want to handle the case differently
      # For example, show no rentals or all rentals - depending on your requirements
      @rentals = Rental.none # Or Rental.all, as needed
    end

    @title = 'Users'

    @users = apply_scopes(@users)
    @users = @users.search_by_name(params[:query]) if params[:query].present?
    @users = @users.active_status(params[:active]) if params[:active].present?

    respond_with(@users) do |format|
      format.html do
        if params[:commit] == 'Clear'
          redirect_back(fallback_location: root_path)
        elsif request.xhr?
          render partial: 'table'
        end
      end
    end
  end

  def fields
    @user = User.find(params[:id])
    @user_rentals = @user.rental
  end

  # GET /users/new
  def new
    @user = User.new
    @title = "New User"
  end

  # GET /users/1/edit
  def edit
    @title = "Edit #{@user.first_name} #{@user.last_name} "
    @alt_list = params[:alt_list]
    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'quick_edit_form'
    else
      render partial: 'quick_edit_form'
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def update_role
    @user = User.find(params[:id])
    if @user.update(user_role_params)
      redirect_to admin_dashboard_users_path, notice: 'User details updated successfully'
    else
      redirect_to admin_dashboard_users_path, alert: 'Failed to update user details'
    end
  end


  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "Access denied!" unless current_user&.role == 'admin'
  end

  # Needs password to verify
  def needs_password?(_user, params)
    params[:password].present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_role_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :address_line,
      :suburb,
      :state,
      :postcode,
      :active,
      :role)
  end
    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :address_line,
      :suburb,
      :state,
      :postcode,
      :active,
      :role
    )
  end
end
