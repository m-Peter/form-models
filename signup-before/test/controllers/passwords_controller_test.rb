require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  test "should get the password changing page" do
    get :new
    password_form = assigns(:password_form)

    assert_response :success
    assert_not_nil password_form
    assert_kind_of PasswordForm, password_form
  end

  test "should change the password" do
    login_as users(:peter)

    post :create, :password_form =>
                  { 
                    :original_password => "secret",
                    :new_password => "37emzf69",
                    :new_password_confirmation => "37emzf69"
                  }
    password_form = assigns(:password_form)

    assert_not_nil password_form
    assert_kind_of PasswordForm, password_form
    assert_redirected_to users(:peter)
    assert_equal "Successfully changed password.", flash[:notice]
  end

end
