require 'test_helper'

class ModelFactoryTest < ActiveSupport::TestCase
  def setup
    @params = ActiveSupport::HashWithIndifferentAccess.new(
      "utf8" => "✓",
      "authenticity_token" => "sWH/peQsFN82g3dsZk8WAVoDhdH3yLJU7ugd/JYccKE=",
      "user" => {
        "name" => "marimar",
        "age" => "21",
        "gender" => "1",
        "email_attributes" => {
          "address" => "marimar@caribbean.gr" }
        },
      "commit" => "Create User"
    )

    @user = User.new
    @factory = FormObject::ModelFactory.new(@user, @params)
  end

  test "model factory contains the attributes" do
    params = ActiveSupport::HashWithIndifferentAccess.new(
      "user" => {
        "name" => "marimar",
        "age" => "21",
        "gender" => "1",
        "email_attributes" => {
          "address" => "marimar@caribbean.gr"
        }
      }
    )

    args = ActiveSupport::HashWithIndifferentAccess.new(
      "model" => @user,
      "association_name" => "user",
      "attrs" => {
        "name" => "marimar",
        "age" => "21",
        "gender" => "1"
      }
    )

    assert_equal params, @factory.attributes
    assert_equal args, @factory.root_populator_args
    
    root_populator = FormObject::Populator::Root.new(@factory.root_populator_args)

    assert_instance_of FormObject::Populator::Root, root_populator
    assert_equal @user, root_populator.model
    assert_equal "user", root_populator.association_name
    assert_nil root_populator.parent
    assert_equal args[:attrs], root_populator.pending_attributes

    root_populator.call
    assert_equal "marimar", @user.name

    populators = @factory.create_populators_for(@user, @factory.attributes.values.first)
    assert_equal params[:user], @factory.attributes.values.first
    assert_equal 1, populators.size

    email_populator = populators.first
    
    assert_instance_of Email, email_populator.model
    assert_equal @user, email_populator.parent
    assert_equal "email", email_populator.association_name
    sub_args = ActiveSupport::HashWithIndifferentAccess.new(
      address: "marimar@caribbean.gr"
    )
    assert_equal sub_args, email_populator.pending_attributes
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
    attrs = ActiveSupport::HashWithIndifferentAccess.new(
      "name" => "marimar",
      "age" => "21",
      "gender" => "1"
    )

    assert_instance_of User, args[:model]
    assert_equal attrs, args[:attrs]
    assert_equal "user", args[:association_name]
  end

  test "root populator populates the root model" do
    model = @factory.populate_model

    assert_equal "marimar", model.name
    assert_equal 21, model.age
    assert_equal 1, model.gender
  end

  test "can create populators for nested models" do
    model = @factory.populate_model

    assert_equal "marimar", model.name
    assert_equal 21, model.age
    assert_equal 1, model.gender
    assert_equal "marimar@caribbean.gr", model.email.address
    models = []
    @factory.populators.each do |pop|
      models << pop.model
    end

    assert_equal 2, models.size
    assert_instance_of User, models.first
    assert_instance_of Email, models.last
  end

  test "can save all the models" do
    model = @factory.populate_model

    assert_difference("User.count") do
      @factory.save!
    end

    assert model.persisted?
    assert model.email.persisted?
  end
end