require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:peter)
  end

  test "user name must be unique" do
    user = User.new(name: "m-peter", age: 23, gender: "0")

    assert_not user.valid?
    assert_includes user.errors.messages[:name], "has already been taken"
  end

end
