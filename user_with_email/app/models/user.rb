class User < ActiveRecord::Base
  has_one :email, dependent: :destroy
  act_as_gendered

  validates :name, :age, :gender, presence: true
  validates :name, length: { in: 6..20 }
  validates :age, numericality: { only_integer: true }
  validates :name, uniqueness: true
end
