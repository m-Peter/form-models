require 'test_helper'

class HasOneTest < ActiveSupport::TestCase
  def setup
    @parent = User.new
    @model = Email.new

    @args = ActiveSupport::HashWithIndifferentAccess.new(
      model: @model,
      association_name: "email",
      attrs: {
        "address" => "petrakos@gmail.com"
      },
      parent: @parent
    )

    @populator = FormObject::Populator::HasOne.new(@args)
  end

  test "contains the according properties" do
    assert_equal @model, @populator.model
    assert_equal "email", @populator.association_name
    assert_equal @args[:attrs], @populator.pending_attributes
    assert_equal @parent, @populator.parent
  end

  test "populates the model" do
    @populator.call

    assert_equal "petrakos@gmail.com", @populator.model.address
    assert_equal @parent.email, @populator.model
  end
end