require 'test_helper'

class ProfilTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @profile = Profile.new(User.new, Email.new)
    @model = @profile
    @new_params = {
      name: "Petros",
      age: 23,
      gender: 0,
      email: "markoupetr@gmail.com"
    }
  end

  test "profile delegates accessors to user" do
    @profile.name = "Peter"
    assert_equal @profile.user.name, @profile.name

    @profile.age = 22
    assert_equal @profile.user.age, @profile.age

    @profile.gender = 0
    assert_equal @profile.user.gender, @profile.gender

    assert_equal @profile.user.persisted?, @profile.persisted?
    assert_equal @profile.user.id, @profile.id
  end

  test "profile delegates email to email address" do
    @profile.email = "markoupetr@gmail.com"
    assert_equal "markoupetr@gmail.com", @profile.email
  end

  test "profile can properly fill in attributes" do
    @profile.attributes = @new_params

    assert_equal @profile.name, @new_params[:name]
    assert_equal @profile.age, @new_params[:age]
    assert_equal @profile.gender, @new_params[:gender]
    assert_equal @profile.email, @new_params[:email]
  end

  test "profile can save the user and email" do
    @profile.attributes = @new_params

    assert_difference("User.count") do
      @profile.save!
    end
  end

  test "profile can update the user and email" do
    @profile.attributes = @new_params
    @profile.save!

    update_params = {
      name: "Petros Markou",
      age: 23,
      gender: 0,
      email: "petrmarkou@gmail.com"
    }

    assert_difference("User.count", 0) do
      @profile.update(update_params)
    end

    assert_equal @profile.name, update_params[:name]
    assert_equal @profile.email, update_params[:email]
  end

  test "profile responds to model_name" do
    assert_respond_to Profile, :model_name
    assert_instance_of ActiveModel::Name, Profile.model_name
    assert_equal "User", Profile.model_name.name
    assert_equal "User", Profile.model_name.human
    assert_equal "user", Profile.model_name.singular
    assert_equal "users", Profile.model_name.plural
  end
end