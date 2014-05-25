require 'test_helper'

class UserFormTest < ActiveSupport::TestCase

  def setup
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      "utf-8" => true,
      "authenticity_token" => "some_token",
      "user" => {
        "name" => "Petrakos",
        "age" => "23",
        "gender" => "0",
        "email_attributes" => {
          "address" => "petrakos@gmail.com"
        }
      }
    )
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(user: @user, email: @email)
  end

  test "contains the objects it represents" do
    assert_equal @user, @user_form.user
    assert_equal @email, @user_form.email
  end

  test "contains the attributes of the objects" do
    attributes = [:name, :name=, :age, :age=, :gender, :gender=, :address, :address=]

    attributes.each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "delegates the attributes to the objects" do
    @user_form.name = "Petrakos"
    @user_form.age = 23
    @user_form.gender = 0
    @user_form.address = "petrakos@gmail.com"

    assert_equal @user_form.name, @user.name
    assert_equal @user_form.age, @user.age
    assert_equal @user_form.gender, @user.gender
    assert_equal @user_form.address, @email.address
  end

  test "assigns submitted parameters to the appropriate attibutes" do
    @user_form.submit(@params)

    assert_equal @user_form.name, @params[:name]
    assert_equal @user_form.age, @params[:age]
    assert_equal @user_form.gender, @params[:gender]
    assert_equal @user_form.address, @params[:address]
  end

  test "#valid? returns true for valid submitted parameters" do
    @user_form.submit(@params)

    assert @user_form.valid?
  end

  test "#valid? should return false for invalid submitted parameters" do
    @user_form.submit(@params)

    assert_not @user_form.valid?
    assert_includes @user_form.errors.messages[:name], "is too short (minimum is 6 characters)"
    assert_includes @user_form.errors.messages[:address], "is invalid"
  end

  test "saves the models" do
    @user_form.submit(@params)

    assert_difference('User.count') do
      @user_form.save
    end

    assert @user_form.persisted?
    assert @user.persisted?
    assert @email.persisted?
    assert_equal @user.email, @email
  end

  test "updates the models" do
    user = User.create!(name: 'Petrakos', age: 23, gender: 0)
    email = Email.create!(address: 'petrakos@gmail.com')
    user_form = UserForm.new(user: user, email: email)

    user_form.submit(@params)

    assert_difference('User.count', 0) do
      user_form.save
    end

    assert_equal "Petros", user_form.name
    assert_equal "petran@gmail.com", user_form.address
  end

end