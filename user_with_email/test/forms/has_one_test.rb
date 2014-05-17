require 'test_helper'

class HasOneTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @email = Email.new
    @params = {
      :model => @email,
      :association_name => :email,
      :parent => @user,
      :attrs => {
        :address => "markoupetr@gmail.com"
      }
    }

    @populator = FormObject::Populator::HasOne.new(@params)
  end

  test "can build the has one association of the parent" do
    @populator.call

    assert_equal @email, @populator.model
    assert_equal @email, @user.email
    assert_equal "markoupetr@gmail.com", @email.address
    assert_equal "markoupetr@gmail.com", @user.email.address
  end
end