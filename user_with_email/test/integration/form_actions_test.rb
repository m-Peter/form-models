require 'test_helper'

class FormActionsTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "creating a user" do
    get "/users/new"
    assert_response :success
    assert_template "_form"

    post "/users", user: {
      name: "Petrakos",
      age: 23,
      gender: 0,
      address: "petrakos@gmail.com"
    }
    follow_redirect!
    assert_response :success
    assert_equal "User: Petrakos was successfully created.", flash[:notice]
    assert_template "show"
  end

  test "updating a user" do
    peter = users(:peter)

    get "/users/#{peter.id}/edit"
    assert_response :success
    assert_template "_form"

    patch "/users/#{peter.id}", id: peter.id, :user => {
      name: "Petran",
      age: 24,
      gender: 1,
      address: "petran@gmail.com"
    }
    follow_redirect!
    assert_response :success
    assert_equal "User: Petran was successfully updated.", flash[:notice]
    assert_template "show"
  end

  test "displaying errors when user params are invalid" do
    get "/users/new"
    assert_response :success
    assert_template "_form"

    post "/users", user: {
      name: "Petr",
      age: 23,
      gender: 0
    }
    assert_response :success
    assert_template "new"
    assert_select "div#error_explanation h2", "1 error prohibited this user from being saved:"
    assert_select "div#error_explanation ul li", "Name is too short (minimum is 6 characters)"
  end
end
