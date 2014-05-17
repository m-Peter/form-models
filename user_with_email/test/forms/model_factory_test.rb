require 'test_helper'

class ModelFactoryTest < ActiveSupport::TestCase
  def setup
    @params = {
      user: {
        name: "Petros",
        age: 23,
        gender: 0,
        email_attributes: {
          address: "cs3199@teilar.gr"
        }
      }
    }

    @factory = FormObject::ModelFactory.new(@params) 
  end

  test "model factory contains the attributes" do
    assert_equal @params, @factory.attributes
  end

  test "model factory initializes the records to save array" do
    assert_equal [], @factory.records_to_save
  end

  test "model factory can populate the models" do
    model = @factory.populate_model
    
    assert_kind_of User, model
    assert_kind_of User, @factory.model
  end

  test "root populator populates the root model with args" do
    @factory.populate_model
    args = @factory.root_populator_args
    attrs = {
      name: "Petros",
      age: 23,
      gender: 0
    }

    assert_instance_of User, args[:model]
    assert_equal attrs, args[:attrs]
    assert_equal :user, args[:association_name]
  end

  test "root populator populates the root model" do
    model = @factory.populate_model

    assert_equal "Petros", model.name
    assert_equal 23, model.age
    assert_equal 0, model.gender
  end
end