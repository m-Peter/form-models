require 'test_helper'

class UserFormFixture < FormObject::Base
  attribute :name, of: :user
  attributes :age, :gender, of: :user
  attribute :address, of: :email

  self.root_model = :user
end

class FormObjectTest < ActiveSupport::TestCase
  def setup
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      "utf-8" => true,
      "authenticity_token" => "some_token",
      "user" => {
        "name" => "Petrakos",
        "age" => "23",
        "gender" => "0",
        "email" => {
          "address" => "petrakos@gmail.com"
        }
      }
    )
    @user = User.new
    @user_form = UserFormFixture.new(@user)
  end

  test "create a new FormObject" do
    assert_kind_of FormObject::Base, @user_form
  end

  test "describe single attribute" do
    assert_respond_to UserFormFixture, :attribute 
  end

  test "create accessors for single attribute" do
    [:name, :name=].each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "describe many attributes" do
    assert_respond_to UserFormFixture, :attributes
  end

  test "create accessors for many attributes" do
    [:age, :age=, :gender, :gender=].each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "specify the root model" do
    assert_equal :user, UserFormFixture.root_model
    assert_equal @user, @user_form.root_model
  end

  test "keep track of the models it represents" do
    assert_equal 2, UserFormFixture.models.size
    assert_equal [:user, :email], UserFormFixture.models
  end

  test "submit incoming parameters" do
    @user_form.submit(@params)

    assert_equal "Petrakos", @user_form.name
    assert_equal "Petrakos", @user_form.user.name

    assert_equal 23, @user_form.age
    assert_equal 23, @user_form.user.age
    
    assert_equal 0, @user_form.gender
    assert_equal 0, @user_form.user.gender
    
    assert_equal "petrakos@gmail.com", @user_form.address
    assert_equal "petrakos@gmail.com", @user_form.email.address
  end

  test "perform validation" do
    @user_form.submit(@params)

    assert @user_form.valid?

    @params[:user][:name] = "Petr"
    @params[:user][:email][:address] = "petrakos"
    @user_form.submit(@params)

    assert_not @user_form.valid?
    assert_includes @user_form.errors.messages[:name], "is too short (minimum is 6 characters)"
    assert_includes @user_form.errors.messages[:address], "is invalid"
  end

  test "submit creates the ModelFactory from the params" do
    @user_form.submit(@params)
    assert_instance_of FormObject::ModelFactory, @user_form.factory
  end

  test "factory contains only the relevant values from params" do
    @user_form.submit(@params)
    assert_equal @params.slice("user"), @user_form.factory.attributes
  end

  test "factory populates the root model" do
    @user_form.submit(@params)
    assert_instance_of User, @user_form.factory.model
  end

  test "saves the models" do
    @user_form.submit(@params)

    assert_difference('User.count') do
      @user_form.save
    end
  end

  test "updates the models" do
    user = users(:peter)
    user_form = UserForm.new(user)

    user_form.submit(@params)
    
    assert_difference('User.count', 0) do
      user_form.save
    end

    assert_equal "Petrakos", user_form.name
    assert_equal "petrakos@gmail.com", user_form.address
  end
end