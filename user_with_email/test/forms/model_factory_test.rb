require 'test_helper'

class ModelFactoryTest < ActiveSupport::TestCase
  def setup
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      "user" => {
        "name" => "Petrakos",
        "age" => "23",
        "gender" => "0",
        "email" => {
          "address" => "petrakos@gmail.com"
        }
      }
    )
    @user = User.new
    @factory = FormObject::ModelFactory.new(@user, @params)
  end

  test "contains the attributes" do
    assert_equal @params, @factory.attributes
  end

  test "instantiates the root model" do
    assert_instance_of User, @factory.populate_model
  end

  test "populates the root model" do
    model = @factory.populate_model

    assert_equal "Petrakos", model.name
    assert_equal 23, model.age
    assert_equal 0, model.gender
  end

  test "build the models" do
    model = @factory.populate_model

    assert_equal 2, @factory.models.size
    assert_equal [:user, :email], @factory.models.keys
    assert_instance_of User, @factory.models[:user]
    assert_instance_of Email, @factory.models[:email]
  end

  test "populates the nested model" do
    model = @factory.populate_model

    assert_equal "Petrakos", model.name
    assert_equal 23, model.age
    assert_equal 0, model.gender
    assert_equal "petrakos@gmail.com", model.email.address
  end

  test "saves the models" do
    model = @factory.populate_model

    assert_difference('User.count') do
      @factory.save!
    end
  end
end