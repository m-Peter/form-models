class UserForm < FormObject::Base
  self.root_model = :user
  
  attributes :name, :age, :gender
  attributes :address, of: :email

  validates :name, :age, :gender, presence: true
  validates :name, length: { in: 6..20 }
  validates :age, numericality: { only_integer: true }

  validates :address, presence: true
  validates_format_of :address, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end