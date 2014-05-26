require 'test_helper'

class UserFormComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @user = User.new(name: 'Petrakos', age: 23, gender: 0)
    @model = UserForm.new(user: @user)
  end

  test "responds to #persisted?" do
    assert_not @model.persisted?

    @user.save
    assert @model.persisted?
  end

  test "responds to #to_key" do
    assert_nil @model.to_key

    @user.save
    assert_equal @user.id, @model.to_key
  end

  test "responds to #to_model" do
    assert_equal @user, @model.to_model
  end

  test "responds to .model_name" do
    assert_equal User.model_name, UserForm.model_name
  end

  test "responds to #to_param" do
    assert_nil @model.to_param

    @user.save
    assert_equal @user.to_param, @model.to_param
  end
end