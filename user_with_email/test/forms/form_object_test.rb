require 'test_helper'

class UserForm < FormObject::Base
  attributes :name, :age, of: :user
  attribute :gender, of: :user
  attribute :address, of: :email
end

class FormObjectTest < ActiveSupport::TestCase
  def setup
    @user_form = UserForm.new(user: User.new)
  end

  test "can specify attribute" do
    assert_respond_to @user_form, :name

    @user_form.name = "Peter"
    assert_equal "Peter", @user_form.name
  end

  test "can specify attributes" do
    assert_respond_to @user_form, :name
    assert_respond_to @user_form, :age

    @user_form.name = "Peter"
    @user_form.age = 23

    assert_equal "Peter", @user_form.name
    assert_equal 23, @user_form.age
  end

  test "can use both attributes and attribute" do
    @user_form.name = "Peter"
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal "Peter", @user_form.name
    assert_equal 23, @user_form.age
    assert_equal 0, @user_form.gender
  end

  test "can respond to attribute and attributes" do
    assert_respond_to UserForm, :attribute
    assert_respond_to UserForm, :attributes
  end

  test "can specify to which model the attributes belong" do
    user = User.new
    user_form = UserForm.new(user: user)
    user_form.name = "Peter"
    user_form.age = 23

    assert_equal "Peter", user.name
    assert_equal 23, user.age
  end

  test "can specify attributes for two different models" do
    user = User.new
    email = Email.new
    user_form = UserForm.new(user: user, email: email)
    user_form.name = "Peter"
    user_form.age = 23
    user_form.address = "markoupetr@gmail.com"

    assert_equal "Peter", user.name
    assert_equal 23, user.age
    assert_equal "markoupetr@gmail.com", email.address
  end

  test "can keep track of each model specified in the attributes directive" do
    user = User.new
    email = Email.new
    user_form = UserForm.new(user: user, email: email)

    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "should not add duplicate models" do
    user = User.new
    email = Email.new
    user_form = UserForm.new(user: user, email: email)

    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "can submit incoming params" do
    user = User.new
    email = Email.new
    user_form = UserForm.new(user: user, email: email)

    params = {
      name: "Peter",
      age: 22,
      gender: 0,
      address: "markoupetr@gmail.com"
    }

    user_form.submit(params)

    assert_equal params[:name], user_form.name
    assert_equal params[:age], user_form.age
    assert_equal params[:gender], user_form.gender
    assert_equal params[:address], user_form.address
  end
end