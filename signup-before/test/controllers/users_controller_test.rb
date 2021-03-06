require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get the signup page" do
    get :new
    signup_form = assigns(:signup_form)

    assert_response :success
    assert_not_nil signup_form
    assert_kind_of SignupForm, signup_form
  end

  test "should redirect to user's profile after successful signup" do
    post :create, :user =>
                  {
                    :username => "mpeter",
                    :email => "markoupetr@gmail.com",
                    :password => "37emzf69",
                    :password_confirmation => "37emzf69",
                    :twitter_name => "m-peter",
                    :github_name => "m-peter",
                    :bio => "Currently a GSoC student."
                  }
    signup_form = assigns(:signup_form)

    assert_not_nil signup_form
    assert_not_nil session[:user_id]
    assert_kind_of SignupForm, signup_form
    assert_redirected_to signup_form.user
    assert_equal "Thank you for signing up!", flash[:notice]
  end

  test "should show logged in user's profile" do
    peter = users(:peter)
    login_as peter
    get :show, {'id' => peter}
    
    logged_in_user = assigns(:user)

    assert_response :success
    assert_not_nil logged_in_user
    assert_equal peter.email, logged_in_user.email
    assert_equal peter.username, logged_in_user.username
    assert_equal peter.profile.twitter_name, logged_in_user.profile.twitter_name
    assert_equal peter.profile.github_name, logged_in_user.profile.github_name
    assert_equal peter.profile.bio, logged_in_user.profile.bio
  end

end
