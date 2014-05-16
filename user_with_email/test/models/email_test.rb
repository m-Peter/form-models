require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  test "email requires address" do
    email = Email.new
    email.address = nil

    assert_not email.valid?
    assert_includes email.errors.messages[:address], "can't be blank"
  end

  test "email address should be valid" do
    email = Email.new
    invalid = ["my_email@email", "@email", "my_email.com"]
    valid = ["cs2619@teilar.gr", "markupetr@gmail.com", "petr.markou@gmail.gr"]

    invalid.each do |address|
      email.address = address
      assert_not email.valid?
    end

    valid.each do |address|
      email.address = address
      assert email.valid?, "#{address} should be a valid email"
    end
  end

  test "email address should be unique" do
    email = Email.new(address: "markoupetr@gmail.com")

    assert_not email.valid?
    assert_includes email.errors.messages[:address], "has already been taken"
  end

end
