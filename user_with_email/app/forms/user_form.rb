require "form_object"

class UserForm < FormObject::Base
  attributes :name, :age, :gender, of: :user
  attributes :address, of: :email

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