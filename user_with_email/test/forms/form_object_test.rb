require 'test_helper'

class UserForm < FormObject::Base
  attribute :name
end

class FormObjectTest < ActiveSupport::TestCase
  test "can specify attribute" do
    user_form = UserForm.new

    assert_respond_to user_form, :name

    user_form.name = "Peter"
    assert_equal "Peter", user_form.name
  end
end