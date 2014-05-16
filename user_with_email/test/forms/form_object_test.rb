require 'test_helper'

class UserForm < FormObject::Base
  attributes :name, :age, of: :user
  attribute :gender, of: :user
  attribute :address, of: :email

  self.main_model = :user
end

class FormObjectTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests
  def setup
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(user: @user, email: @email)
    @model = @user_form
  end

  test "can specify attribute" do
    assert_respond_to @user_form, :name

    @user_form.name = "Petros"
    assert_equal "Petros", @user_form.name
  end

  test "can specify attributes" do
    assert_respond_to @user_form, :name
    assert_respond_to @user_form, :age

    @user_form.name = "Petros"
    @user_form.age = 23

    assert_equal "Petros", @user_form.name
    assert_equal 23, @user_form.age
  end

  test "can use both attributes and attribute" do
    @user_form.name = "Petros"
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal "Petros", @user_form.name
    assert_equal 23, @user_form.age
    assert_equal 0, @user_form.gender
  end

  test "can respond to attribute and attributes" do
    assert_respond_to UserForm, :attribute
    assert_respond_to UserForm, :attributes
  end

  test "can specify the main model of the form" do
    assert_equal :user, UserForm.main_model
  end

  test "can specify to which model the attributes belong" do
    @user_form.name = "Petros"
    @user_form.age = 23

    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
  end

  test "can specify attributes for two different models" do
    @user_form.name = "Petros"
    @user_form.age = 23
    @user_form.address = "markoupetr@gmail.com"

    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
    assert_equal "markoupetr@gmail.com", @email.address
  end

  test "can keep track of each model specified in the attributes directive" do
    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "should not add duplicate models" do
    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "can submit incoming params" do
    params = {
      name: "Petros",
      age: 22,
      gender: 0,
      address: "markoupetr@gmail.com"
    }

    @user_form.submit(params)

    assert_equal params[:name], @user_form.name
    assert_equal params[:age], @user_form.age
    assert_equal params[:gender], @user_form.gender
    assert_equal params[:address], @user_form.address
  end

  test "can save the form" do
    params = {
      name: "Petros",
      age: 22,
      gender: 0,
      address: "cs3199@teilar.gr"
    }

    @user_form.submit(params)

    assert_difference("User.count") do
      @user_form.save
    end
  end

  test "can respond to persisted?" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    assert user.persisted?

    user_form = UserForm.new(user: user)
    assert user_form.persisted?
  end

  test "can respond to to_key" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    user_form = UserForm.new(user: user)

    assert_equal user.to_key, user_form.to_key
  end

  test "can respond to to_model" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    user_form = UserForm.new(user: user)

    assert_equal user, user_form.to_model
  end

  test "can respond to id" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    user_form = UserForm.new(user: user)

    assert_equal user.id, user_form.id
  end

  test "can respond to to_param" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    user_form = UserForm.new(user: user)

    assert_equal user.to_param, user_form.to_param
  end

  test "can respond to model_name" do
    user = User.create!(name: "Petros", age: 23, gender: 0)
    user_form = UserForm.new(user: user)

    assert_equal User.model_name, UserForm.model_name
  end
end