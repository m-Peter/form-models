require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:peter)
  end

  test "should get index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new

    assert_response :success

    assert_not_nil assigns(:user_form)
    assert_kind_of UserForm, assigns(:user_form)
  end

  test "should create user" do
    post :create, :user =>
    {
      name: "Mariam",
      age: 21,
      gender: "1",
      address: "mariam@gmail.com"
    }
    user_form = assigns(:user_form)

    assert_not_nil user_form
    assert_kind_of UserForm, user_form
    assert_redirected_to user_form.user
    assert_equal "User was successfully created.", flash[:notice]
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    post :update, id: @user, :user =>
    {
      name: "Marimar",
      age: 22,
      gender: "1",
      address: "marimar@gmail.com"
    }
    user_form = assigns(:user_form)

    assert_not_nil user_form
    assert_kind_of UserForm, user_form
    assert_redirected_to user_form.user
    assert_equal "User was successfully updated.", flash[:notice]
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
