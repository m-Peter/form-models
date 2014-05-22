class UserForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  delegate :name, :name=, :age, :age=, :gender, :gender=, to: :model

  def initialize(user)
    @user = user
  end

  def valid?
    result = super
    valid = model.valid? && result

    model.errors.each do |attribute, error|
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
      model.save!
    end
  end

  def persisted?
    model.persisted?
  end

  def to_key
    return nil unless persisted?
    model.id
  end

  def to_model
    model
  end

  def to_param
    return nil unless persisted?
    model.id.to_s
  end

  def model
    @user
  end
end