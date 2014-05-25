require "form_object"

class UserForm < FormObject::Base
  attributes :name, :age, :gender, of: :user
  attributes :address, of: :email

  self.root_model = :user
end