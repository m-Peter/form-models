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
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_form)
    assert_instance_of UserForm, assigns(:user_form)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: 'Petrakos', age: 23, gender: 0 }
    end

    assert_redirected_to user_path(assigns(:user))
    assert_equal "User: Petrakos was successfully created.", flash[:notice]
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
    assert_select ".field", 3
    assert_select "form[action=?]", "#{users_path}/#{@user.id}"
    assert_select "form[class=?]", "edit_user"
    assert_select "form[id=?]", "edit_user_#{@user.id}"
    assert_select "form[method=?]", "post"
    assert_select "form input[id=user_name][value=?]", @user.name
    assert_select "form input[id=user_age][value=?]", @user.age
    assert_select "form select option[selected=selected][value=?]", @user.gender
    assert_select "form input[name=commit][value=?]", "Update User"
  end

  test "should update user" do
    post :update, id: @user.id, :user =>
    {
      name: "Mariam",
      age: 21,
      gender: 1
    }

    assert_equal "Mariam", assigns(:user).name
    assert_redirected_to assigns(:user)
    assert_equal "User: Mariam was successfully updated.", flash[:notice]
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
    assert_equal "User: #{@user.name} was successfully destroyed.", flash[:notice]
  end
end
