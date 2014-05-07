class PasswordChangeTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = PasswordForm.new(users(:peter))
  end
end