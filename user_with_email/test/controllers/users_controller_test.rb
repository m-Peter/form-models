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
    assert_select "form input", 5
    assert_select ".field", 4
    assert_select "form[action=?]", "/users"
    assert_select "form[class=?]", "new_user"
    assert_select "form[id=?]", "new_user"
    assert_select "form[method=?]", "post"
    assert_select "form input[name=commit][value=?]", "Create User"
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
    assert_select ".field", 4
    assert_select "form[action=?]", "#{users_path}/#{@user.id}"
    assert_select "form[class=?]", "edit_user"
    assert_select "form[id=?]", "edit_user_#{@user.id}"
    assert_select "form[method=?]", "post"
    assert_select "form input[id=user_name][value=?]", @user.name
    assert_select "form input[id=user_age][value=?]", @user.age
    assert_select "form select option[selected=selected][value=?]", @user.gender
    assert_select "form input[id=user_address][value=?]", @user.email.address
    assert_select "form input[name=commit][value=?]", "Update User"
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
