require 'test_helper'

class RootPopulatorTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @params = {
      :model => @user,
      :association_name => :user,
      :attrs => {
        :name => "Petros",
        :age => 23,
        :gender => 0
      },
    }

    @populator = FormObject::Populator::Root.new(@params)
  end

  test "it populates the model" do
    @populator.call
    
    assert_equal "Petros", @user.name
    assert_equal 23, @user.age
    assert_equal 0, @user.gender
  end
end