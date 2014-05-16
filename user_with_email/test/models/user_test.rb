require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:peter)
  end

  test "user requires name" do
    @user.name = nil
    
    assert_not @user.valid?
    assert_includes @user.errors.messages[:name], "can't be blank"
  end

  test "user name must have a length between 6 and 20" do
    @user.name = "short"
    
    assert_not @user.valid?
    assert_includes @user.errors.messages[:name], "is too short (minimum is 6 characters)"

    @user.name = "too big name to remember by a user"
    
    assert_not @user.valid?
    assert_includes @user.errors.messages[:name], "is too long (maximum is 20 characters)"
  end

  test "user name must be unique" do
    user = User.new(name: "m-peter", age: 23, gender: "0")

    assert_not user.valid?
    assert_includes user.errors.messages[:name], "has already been taken"
  end

  test "user requires age" do
    @user.age = nil

    assert_not @user.valid?
    assert_includes @user.errors.messages[:age], "can't be blank"
  end

  test "age should be integer" do
    user = User.new
    user.age = "12"
    assert_not user.valid?

    user.age = 12.25
    assert_not user.valid?

    user.age = true
    assert_not user.valid?
  end

  test "user requires gender" do
    @user.gender = nil

    assert_not @user.valid?
    assert_includes @user.errors.messages[:gender], "can't be blank"
  end

  test "gender should contain 0 or 1" do
    user = User.new
    user.gender = 0
    assert_not user.valid?

    user.gender = "male"
    assert_not user.valid?
  end

  test "valid data" do
    user = User.new(name: "m-Peter", age: 23, gender: "0")

    assert_difference("User.count", 1) do
      user.save!
    end
  end

end
