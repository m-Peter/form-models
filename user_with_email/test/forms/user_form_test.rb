require 'test_helper'

class UserFormTest < ActiveSupport::TestCase
  

  def setup
    @user = User.new
    @user_form = UserForm.new(@user)
  end

  test "should contain the object it represents" do
    assert_equal @user, @user_form.model
  end

  test "should contain the attributes of the object" do
    attributes = [:name, :name=, :age, :age=, :gender, :gender=]

    attributes.each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "should delegates the attributes to the object" do
    @user_form.name = "Petrakos"
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal @user_form.name, @user.name
    assert_equal @user_form.age, @user.age
    assert_equal @user_form.gender, @user.gender
  end
end