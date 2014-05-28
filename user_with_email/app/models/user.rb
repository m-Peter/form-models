class User < ActiveRecord::Base
  has_one :email, dependent: :destroy
  act_as_gendered
  
  validates :name, uniqueness: true
end
