class UserForm
  delegate :name, :name=, :age, :age=, :gender, :gender=, to: :model

  def initialize(user)
    @user = user
  end

  def model
    @user
  end
end