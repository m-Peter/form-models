class Profile
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :user

  delegate :name, :name=, :password, :password=, :password_confirmation,
           :password_confirmation=, :persisted?, :id, :to => :user,
           :prefix => false, :allow_nil => false

  def initialize(user, email)
    @user = user
    @email = email
    @email.confirmed = false
  end

  def email
    @email.address
  end

  def email=(email_addr)
    @email.address = email_addr
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end

  def save!
    User.transaction do
      @user.email = @email
      @user.save!
    end
  end
end