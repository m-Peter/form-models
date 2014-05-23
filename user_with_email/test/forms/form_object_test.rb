require 'test_helper'

class UserFormFixture < FormObject::Base
  attribute :name
  attributes :age, :gender
end

class FormObjectTest < ActiveSupport::TestCase
  def setup
    @user_form = UserFormFixture.new
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
end