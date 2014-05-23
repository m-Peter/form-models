require 'test_helper'

class UserFormTest < ActiveSupport::TestCase

  def setup
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(@user, @email)
  end

  test "should contain the objects it represents" do
    assert_equal @user, @user_form.user
    assert_equal @email, @user_form.email
  end

  test "should contain the attributes of the objects" do
    attributes = [:name, :name=, :age, :age=, :gender, :gender=, :address, :address=]

    attributes.each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "should delegates the attributes to the objects" do
    @user_form.name = "Petrakos"
    @user_form.age = 23
    @user_form.gender = 0
    @user_form.address = "petrakos@gmail.com"

    assert_equal @user_form.name, @user.name
    assert_equal @user_form.age, @user.age
    assert_equal @user_form.gender, @user.gender
    assert_equal @user_form.address, @email.address
  end

  test "should submit params" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: 'petrakos@gmail.com' }
    @user_form.submit(params)

    assert_equal @user_form.name, params[:name]
    assert_equal @user_form.age, params[:age]
    assert_equal @user_form.gender, params[:gender]
    assert_equal @user_form.address, params[:address]
  end

  test "submit should return true if the params are valid" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: "petrakos@gmail.com" }
    result = @user_form.submit(params)

    assert result
  end

  test "submit should return false for invalid params" do
    params = { name: 'Petr', age: "12", gender: "male", address: 'petr' }
    result = @user_form.submit(params)

    assert_not result
    assert_includes @user_form.errors.messages[:name], "is too short (minimum is 6 characters)"
    assert_includes @user_form.errors.messages[:address], "is invalid"
  end

  test "should save the models" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: 'petrakos@gmail.com' }
    @user_form.submit(params)

    assert_difference('User.count') do
      @user_form.save
    end

    assert @user_form.persisted?
    assert @user.persisted?
    assert @email.persisted?
    assert_equal @user.email, @email
  end

  test "should update the models" do
    user = User.create!(name: 'Petrakos', age: 23, gender: 0)
    email = Email.create!(address: 'petrakos@gmail.com')
    user_form = UserForm.new(user, email)

    user_form.submit({name: "Petros", address: 'petran@gmail.com'})

    assert_difference('User.count', 0) do
      user_form.save
    end

    assert_equal "Petros", user_form.name
    assert_equal "petran@gmail.com", user_form.address
  end

end