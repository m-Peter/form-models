require 'test_helper'

class ModelFactoryTest < ActiveSupport::TestCase
  def setup
    @params = {
      user: {
        name: "Petros",
        age: 22,
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
end