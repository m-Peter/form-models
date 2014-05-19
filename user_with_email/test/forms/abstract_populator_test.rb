require 'test_helper'

class AbstractPopulatorTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      :model => @user,
      :association_name => :user,
      :attrs => {
        :name => "Petros",
        :age => 23,
        :gender => 0
      }
    )

    @populator = FormObject::Populator::Abstract.new(@params)
  end

  test "should contains the model, association name and attributes" do
    assert_equal @user, @populator.model
    assert_equal :user, @populator.association_name
    assert_equal @params[:attrs], @populator.pending_attributes
  end

  test "should delegates the responsibility of assigning attributes to subclasses" do
    assert_raises(NotImplementedError) { @populator.call }
  end

  test "should cooperate" do
    user = User.new
    root = ActiveSupport::HashWithIndifferentAccess.new(
      :model => user,
      :association_name => :user,
      :attrs => {
        :name => "Petros",
        :age => 23,
        :gender => 0
      }
    )

    email = Email.new
    has_one = ActiveSupport::HashWithIndifferentAccess.new(
      :model => email,
      :association_name => :email,
      :parent => user,
      :attrs => {
        :address => "markoupetr@gmail.com"
      }
    )

    root_populator = FormObject::Populator::Root.new(root)
    has_one_populator = FormObject::Populator::HasOne.new(has_one)

    populators = [root_populator, has_one_populator]
    
    populators.each do |p|
      p.call
    end

    assert_instance_of User, root_populator.model
    assert_instance_of Email, has_one_populator.model
    assert_equal "Petros", user.name
    assert_equal 23, user.age
    assert_equal 0, user.gender
    assert_equal "markoupetr@gmail.com", email.address
    assert_equal user.email, email
  end
end