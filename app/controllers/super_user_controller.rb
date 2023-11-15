class SuperUserController < ApplicationController
  class SuperUsersController < ApplicationController
    before_action :set_super_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    load_and_authorize_resource

    # GET /super_users
    def index
      @super_users = User.super_users # Assuming a scope or method to fetch super users
    end

    # GET /super_users/1
    def show
      # Show a specific super user details
    end

    # GET /super_users/new
    def new
      @super_user = User.new
    end

    # GET /super_users/1/edit
    def edit
      # Edit a specific super user details
    end

    # POST /super_users
    def create
      @super_user = User.new(super_user_params)

      if @super_user.save
        redirect_to @super_user, notice: 'Super user was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /super_users/1
    def update
      if @super_user.update(super_user_params)
        redirect_to @super_user, notice: 'Super user was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /super_users/1
    def destroy
      @super_user.destroy
      redirect_to super_users_url, notice: 'Super user was successfully destroyed.'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_super_user
      @super_user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def super_user_params
      params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
    end
  end
end
