class PasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :original_password, :new_password

  validate :verify_original_password
  validates_presence_of :original_password, :new_password
  validates_confirmation_of :new_password
  validates_length_of :new_password, minimum: 6

  def initialize(user)
    @user = user
  end

  def to_model
    self
  end

  def submit(params)
    self.original_password = params[:original_password]
    self.new_password = params[:new_password]
    self.new_password_confirmation = params[:new_password_confirmation]

    if valid?
      @user.password = new_password
      @user.save!
      true
    else
      false
    end
  end

  def persisted?
    false
  end

  def verify_original_password
    unless @user.authenticate(original_password)
      errors.add :original_password, "is not correct"
    end
  end
end