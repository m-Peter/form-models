require 'test_helper'

class UserForm < FormObject::Base
  attributes :name, :age, of: :user
  attribute :gender, of: :user
  attribute :address, of: :email

  self.root_model = :user
end

class FormObjectTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests
  
  def setup
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      "utf8" => true,
      user: {
        name: "Petros",
        age: 22,
        gender: 0,
        email_attributes: {
          address: "cs3199@teilar.gr"
        }
      },
      "commit" => "Create User",
      "controller" => "users"
    )
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(user: @user, email: @email)
    @model = @user_form
  end

  test "should specify single `.attribute`" do
    assert_respond_to @user_form, :name

    @user_form.name = "Petros"
    assert_equal "Petros", @user_form.name
  end

  test "should specify many `.attributes`" do
    assert_respond_to @user_form, :name
    assert_respond_to @user_form, :age

    @user_form.name = "Petros"
    @user_form.age = 23

    assert_equal "Petros", @user_form.name
    assert_equal 23, @user_form.age
  end

  test "should use both `.attributes` and `.attribute`" do
    @user_form.name = "Petros"
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal "Petros", @user_form.name
    assert_equal 23, @user_form.age
    assert_equal 0, @user_form.gender
  end

  test "should respond to `.attribute` and `.attributes`" do
    assert_respond_to UserForm, :attribute
    assert_respond_to UserForm, :attributes
  end

  test "should specify the `.root_model` of the form" do
    assert_equal @user, @user_form.root_model
    assert_equal :user, UserForm.root_model
    assert_equal User, UserForm.root_model.to_s.camelize.constantize
    assert_equal ActiveModel::Name.new(User), ActiveModel::Name.new(UserForm.root_model.to_s.camelize.constantize)
  end

  test "should delegate the `.attributes` to their models" do
    @user_form.name = "Petros"
    @user_form.age = 23

    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
  end

  test "should specify `.attributes` for two different models" do
    @user_form.name = "Petros"
    @user_form.age = 23
    @user_form.address = "markoupetr@gmail.com"

    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
    assert_equal "markoupetr@gmail.com", @email.address
  end

  test "shoukd keep track of each model specified" do
    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "should not add duplicate models" do
    assert_equal 2, UserForm.models.count
    assert_equal [:user, :email], UserForm.models
  end

  test "should `submit` incoming params" do
    @user_form.submit(@params)

    model = @user_form.factory.model
    assert_equal "Petros", model.name
    assert_equal 22, model.age
    assert_equal 0, model.gender
    assert_equal "cs3199@teilar.gr", model.email.address
  end

  test "should `save` the form" do
    @user_form.submit(@params)

    assert_difference("User.count") do
      @user_form.save
    end

    model = @user_form.factory.model

    assert model.persisted?
    assert model.email.persisted?
  end

  test "should respond to `persisted?`" do
    user = create_user
    assert user.persisted?

    user_form = user_form(user)
    assert user_form.persisted?
  end

  test "should respond to `to_key`" do
    user = User.new(name: "Petros", age: 23, gender: 0)
    user_form = user_form(user)
    
    assert_nil user_form.to_key
    assert_equal user.to_key, user_form.to_key

    user.save
    assert_equal user.to_key, user_form.to_key
  end

  test "should respond to `to_model`" do
    user = create_user
    user_form = user_form(user)

    assert_equal user, user_form.to_model
  end

  test "should respond to `id`" do
    user = create_user
    user_form = user_form(user)

    assert_equal user.id, user_form.id
  end

  test "should respond to `to_param`" do
    user = User.new(name: "Petros", age: 23, gender: 0)
    user_form = user_form(user)

    assert_nil user_form.to_param

    user.save
    assert_equal user.to_param, user_form.to_param
  end

  test "should respond to `model_name`" do
    user = create_user
    user_form = user_form(user)

    assert_equal User.model_name, UserForm.model_name
  end

  test "should create an model `factory` on submit" do
    @user_form.submit(@params)

    assert_kind_of FormObject::ModelFactory, @user_form.factory
  end

  test "should `save` all the models" do
    @user_form.submit(@params)
    model = @user_form.factory.model

    @user_form.save

    assert_instance_of User, model
  end

  private

    def create_user
      User.create!(name: "Petros", age: 23, gender: 0)
    end

    def user_form(user)
      UserForm.new(user: user)
    end
end