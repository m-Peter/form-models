class PasswordChangeTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = PasswordForm.new(users(:peter))
  end

  test "it requires the original password" do
    @model.original_password = nil
    assert_not @model.valid?
  end

  test "it requires the new password" do
    @model.new_password = nil
    assert_not @model.valid?
  end

  test "it requires a new password of length greater or equal than 6" do
    @model.new_password = "short"
    assert_not @model.valid?
  end

  test "it requires a valid original password" do
    @model.original_password = "wrong"
    assert_not @model.valid?
    assert_equal ["is not correct"], @model.errors[:original_password]
  end

  test "it changes the password with valid data" do
    params = {
      :original_password => "secret",
      :new_password => "my_new_pass",
      :new_password_confirmation => "my_new_pass"
    }

    assert @model.submit(params)
    assert_equal "my_new_pass", users(:peter).password
  end

  test "it does not change the password with invalid data" do
    params = {
      :original_password => "wrong",
      :new_password => "short",
      :new_password_confirmation => "typo"
    }

    assert_not @model.submit(params)
    assert_equal ["is not correct"], @model.errors[:original_password]
    assert_equal ["is too short (minimum is 6 characters)"], @model.errors[:new_password]
  end
end