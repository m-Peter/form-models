require 'test_helper'

class RootPopulatorTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @args = ActiveSupport::HashWithIndifferentAccess.new(
      model: @user,
      association_name: "user",
      attrs: {
        name: "Petrakos",
        age: 23,
        gender: 0
      }
    )

    @populator = FormObject::Populator::Root.new(@args)
  end

  test "contains the model, association_name and its attributes" do
    assert_equal @user, @populator.model
    assert_equal "user", @populator.association_name
    assert_equal @args[:attrs], @populator.pending_attributes
  end

  test "populates the model with the attributes" do
    @populator.call
    
    assert_equal "Petrakos", @user.name
    assert_equal 23, @user.age
    assert_equal 0, @user.gender
  end
end