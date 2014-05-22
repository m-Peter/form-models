require 'test_helper'

class FormActionsTest < ActionDispatch::IntegrationTest
  test "creating a user" do
    get "/users/new"
    assert_response :success
    assert_template "_form"

    post "/users", user: {
      name: "Petrakos",
      age: 23,
      gender: 0
    }
    follow_redirect!
    assert_response :success
    assert_equal "User: Petrakos was successfully created.", flash[:notice]
    assert_template "show"
  end
end
