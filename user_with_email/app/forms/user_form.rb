class UserForm < FormObject::Base
  attributes :name, :age, :gender, of: :user
  attribute :address, of: :email
end