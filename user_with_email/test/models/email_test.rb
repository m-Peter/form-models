require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  test "email address should be unique" do
    email = Email.new(address: "markoupetr@gmail.com")

    assert_not email.valid?
    assert_includes email.errors.messages[:address], "has already been taken"
  end

end
