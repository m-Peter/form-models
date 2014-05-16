class Profile
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :user
  attr_reader :email

  delegate :name, :name=, :age, :age=, :gender, :gender=,
           :persisted?, :id, to: :user, prefix: false,
           allow_nil: false

  def self.model_name
    ActiveModel::Name.new(@user, nil, "User")
  end

  def initialize(user, email)
    @user = user
    @email = email
    @email.confirmed = false
  end

  def email
    @email.address
  end

  def email=(email_address)
    @email.address = email_address
  end

  def attributes=(attributes)
    attributes.each { |key, value| self.send("#{key}=", value) }
  end

  def save!
    ActiveRecord::Base.transaction do
      @user.email = @email
      @user.save!
    end
  end

  def update(params)
    @user.email.update(address: params[:email])
    @user.update(params.slice(:name, :age, :gender))
  end
end