require 'test_helper'

class UserFormFixture < FormObject::Base
  attribute :name, of: :user
  attributes :age, :gender, of: :user
  attribute :address, of: :email

  self.root_model = :user
end

class FormObjectTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @email = Email.new
    @user_form = UserFormFixture.new(user: @user, email: @email)
  end

  test "create a new FormObject" do
    assert_kind_of FormObject::Base, @user_form
  end

  test "describe single attribute" do
    assert_respond_to UserFormFixture, :attribute 
  end

  test "creates accessors for single attribute" do
    @user_form.name = "Peter"

    assert_equal "Peter", @user_form.name
  end

  test "describe many attributes" do
    assert_respond_to UserFormFixture, :attributes
  end

  test "creates accessors for many attributes" do
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal 23, @user_form.age
    assert_equal 0, @user_form.gender
  end

  test "specifies the root model" do
    assert_equal :user, UserFormFixture.root_model
    assert_equal @user, @user_form.root_model
  end

  test "delegates attribute to model" do
    @user_form.name = "Peter"

    assert_equal "Peter", @user.name
  end

  test "delegate attributes to model" do
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal 23, @user.age
    assert_equal 0, @user.gender
  end

  test "delegate attributes to different models" do
    @user_form.address = "markoupetr@gmail.com"

    assert_equal "markoupetr@gmail.com", @email.address
  end

  test "keeps track of the models it represents" do
    assert_equal 2, UserFormFixture.models.size
    assert_equal [:user, :email], UserFormFixture.models
  end

  test "submits incoming parameters" do
    params = { name: "Petros", age: 23, gender: 0, address: "markoupetr@gmail.com" }
    @user_form.submit(params)

    assert_equal "Petros", @user_form.name
    assert_equal 23, @user_form.age
    assert_equal 0, @user_form.gender
    assert_equal "markoupetr@gmail.com", @user_form.address
  end

  test "performs validation" do
    params = { name: "Petros", age: 23, gender: 0, address: "petrakos@gmail.com" }
    @user_form.submit(params)

    assert @user_form.valid?

    @user_form.name = "Petr"

    assert_not @user_form.valid?
  end
end