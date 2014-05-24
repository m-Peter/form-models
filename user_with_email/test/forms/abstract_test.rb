require 'test_helper'

class AbstractTest < ActiveSupport::TestCase

  test "describes single model" do
    model = User.new

    args = ActiveSupport::HashWithIndifferentAccess.new(
      model: model,
      association_name: "user",
      attrs: {
        "name" => "Petrakos",
        "age" => 23,
        "gender" => 0
      }
    )

    populator = FormObject::Populator::Abstract.new(args)
    assert_equal model, populator.model
    assert_equal "user", populator.association_name
    assert_equal args[:attrs], populator.pending_attributes
  end

  test "describes nested models" do
    parent = User.new
    model = Email.new

    args = ActiveSupport::HashWithIndifferentAccess.new(
      model: model,
      association_name: "email",
      attrs: {
        "address" => "petrakos@gmail.com"
      },
      parent: parent
    )

    populator = FormObject::Populator::Abstract.new(args)
    assert_equal model, populator.model
    assert_equal "email", populator.association_name
    assert_equal args[:attrs], populator.pending_attributes
    assert_equal parent, populator.parent
  end
end