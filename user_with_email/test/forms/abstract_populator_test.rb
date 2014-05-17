require 'test_helper'

class AbstractPopulatorTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @params = {
      :model => @user,
      :association_name => :user,
      :attrs => {
        :name => "Petros",
        :age => 23,
        :gender => 0
      }
    }

    @populator = FormObject::Populator::Abstract.new(@params)
  end

  test "it contains the model, association name and attributes" do
    assert_equal @user, @populator.model
    assert_equal :user, @populator.association_name
    assert_equal @params[:attrs], @populator.pending_attributes
  end

  test "it delegates the responsibility of assigning attributes to subclasses" do
    assert_raises(NotImplementedError) { @populator.call }
  end
end