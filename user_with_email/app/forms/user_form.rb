class UserForm < FormObject::Base
  attributes :name, :age, :gender, of: :user
  attribute :address, of: :email

  self.root_model = :user
end