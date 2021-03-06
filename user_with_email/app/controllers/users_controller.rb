class UsersController < ApplicationController
  before_action :user, only: [:show, :destroy]
  before_action :create_new_form, only: [:new, :create]
  before_action :create_edit_form, only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    ActionController::Parameters.permit_all_parameters = true
    @user_form.submit(params)

    respond_to do |format|
      if @user_form.valid?
        @user_form.save
        format.html { redirect_to @user_form, notice: "User: #{@user_form.name} was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    ActionController::Parameters.permit_all_parameters = true
    @user_form.submit params

    respond_to do |format|
      if @user_form.valid?
        @user_form.save
        format.html { redirect_to @user_form, notice: "User: #{@user_form.name} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    name = @user.name
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User: #{name} was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user
      @user = User.find(params[:id])
    end

    def create_new_form
      @user_form = UserForm.new(user: User.new, email: Email.new)
    end

    def create_edit_form
      @user_form = UserForm.new(user: user, email: user.email)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :gender, email: [:address])
    end
end
