class Signup
	include Virtus

	extend ActiveModel::Naming
	include ActiveModel::Conversion
	include ActiveModel::Validations

	attr_accessor :user
	attr_accessor :company

	attribute :user_name, String
	attribute :company_name, String
	attribute :user_email, String

	validates :user_email, presence: true
	validates :company_name, presence: true
	validates :user_name, presence: true

	def persisted?
		false
	end

	def save
		if valid?
			persist!
			true
		else
			false
		end
	end

	private

		def persist!
			@company = Company.create(name: company_name)
			@company.build_user(name: user_name, email: user_email)
			@company.save!
		end
end