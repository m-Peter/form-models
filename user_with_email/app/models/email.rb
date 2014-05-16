class Email < ActiveRecord::Base
  belongs_to :user

  validates :address, uniqueness: true
  validates :address, presence: true
  validates_format_of :address, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
