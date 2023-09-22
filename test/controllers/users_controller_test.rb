require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    # If you have a field like `admin` in your user model to check if the user is an admin
    @user.update(role: 'admin')
  end

  def login_admin(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123", role: "user" } }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    login_admin(@user)
    get edit_user_url(@user)
    patch user_url(@user), params: { user: { name: @user.name} }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end