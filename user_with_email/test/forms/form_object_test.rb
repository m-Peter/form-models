require 'test_helper'

class UserForm < FormObject::Base
  attributes :name, :age
  attribute :gender
end

class FormObjectTest < ActiveSupport::TestCase
  def setup
    @user_form = UserForm.new
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
end