class SignupTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = SignupForm.new
  end

  test "it requires a username" do
    @model.user.username = nil
    assert_not @model.valid?
  end

  test "it requires a valid email format" do
    @model.user.email = "my-email"
    assert_not @model.valid?
  end

  test "it requires a password of length greater or equal to 6" do
    @model.user.password = "short"
    assert_not @model.valid?
  end

  test "it requires a unique username" do
    @model.user.username = "m-peter"
    assert_not @model.valid?
    assert_equal ["has already been taken"], @model.errors[:username]
  end

  test "it can submit valid data" do
    params = {
      :username => "pmarkou",
      :email => "pmarkou@gmail.com",
      :password => "secret",
      :password_confirmation => "secret",
      :twitter_name => "p-markou",
      :github_name => "p-markou",
      :bio => "Computer Science graduate",
      :subscribed => "1",
    }

    assert @model.submit(params)
    assert @model.errors.messages.empty?
  end
end