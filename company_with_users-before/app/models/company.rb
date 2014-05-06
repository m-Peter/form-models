class Company < ActiveRecord::Base
  has_one :user
end
