class UserForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  delegate :name, :name=, :age, :age=, :gender, :gender=, to: :user
  delegate :address, :address=, to: :email
  attr_reader :user, :email

  def initialize(user, email)
    @user = user
    @email = email
  end

  def valid?
    result = super
    valid = user.valid? & email.valid? & result
    
    user.errors.each do |attribute, error|
      errors.add(attribute, error)
    end

    email.errors.each do |attribute, error|
      errors.add(attribute, error)
    end

    valid
  end

  def submit(params)
    params.each do |key, value|
      send("#{key}=", value)
    end
    valid?
  end

  def save
    ActiveRecord::Base.transaction do
      user.email = email
      user.save!
    end
  end

  def persisted?
    user.persisted?
  end

  def to_key
    return nil unless persisted?
    user.id
  end

  def to_model
    user
  end

  def to_param
    return nil unless persisted?
    user.id.to_s
  end
end