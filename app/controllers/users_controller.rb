class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authorize_admin, only: [:edit, :update, :index, :show]

  # GET /users or /users.json
  def index
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize! :edit, @user
  end

  def admin_dashboard_users
    if params[:query].present?
      query = "%#{params[:query]}%" # Add '%' for partial matching
      @users = @user.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", query, query, query)
    else
      @users = @user.all
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
      :role
    )
  end
end
