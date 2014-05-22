require 'test_helper'

class UserFormComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = UserForm.new(User.new)
  end

  test "responds to #persisted?" do
    user = User.new(name: 'Petrakos', age: 23, gender: 0)
    user_form = UserForm.new(user)

    assert_not user_form.persisted?

    user.save

    assert user_form.persisted?
  end

  test "responds to #to_key" do
    user = User.new(name: 'Petrakos', age: 23, gender: 0)
    user_form = UserForm.new(user)

    assert_nil user_form.to_key

    user.save

    assert_equal user.id, user_form.to_key
  end

  test "responds to #to_model" do
    user = User.new(name: 'Petrakos', age: 23, gender: 0)
    user_form = UserForm.new(user)

    assert_equal user, user_form.to_model
  end

  test "responds to #to_param" do
    user = User.new(name: 'Petrakos', age: 23, gender: 0)
    user_form = UserForm.new(user)

    assert_nil user_form.to_param

    user.save

    assert_equal user.to_param, user_form.to_param
  end
end