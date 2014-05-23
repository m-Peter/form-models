require 'test_helper'

class UserFormFixture < FormObject::Base
end

class FormObjectTest < ActiveSupport::TestCase
  test "create a new FormObject" do
    user_form = UserFormFixture.new
    assert_kind_of FormObject::Base, user_form
  end
end