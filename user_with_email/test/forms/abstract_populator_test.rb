require 'test_helper'

class AbstractPopulatorTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @params = {
      :model => @user,
      :association_name => :user,
      :pending_attributes => {
        :name => "Petros",
        :age => 23,
        :gender => 0
      },
    }

    @populator = FormObject::Populator::Abstract.new(@params)
  end

  test "it contains the model, association name and attributes" do
    assert_equal @user, @populator.model
    assert_equal :user, @populator.association_name
    assert_equal @params[:pending_attributes], @populator.pending_attributes
  end

  test "it can populate the model with the attributes" do
    @populator.call

    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
    assert_equal 0, @user.gender
  end
end