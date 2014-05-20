class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    user = User.new
    @user_form = UserForm.new(user: user)
  end

  # GET /users/1/edit
  def edit
    @user_form = UserForm.new(user: @user, email: @user.email)
  end

  # POST /users
  # POST /users.json
  def create
    @user_form = UserForm.new(user: User.new, email: Email.new)
    # This is a dirty-fix to check that it creates the models.
    params.class.permit_all_parameters = true
    @user_form.submit(params)

    respond_to do |format|
      if @user_form.save
        format.html { redirect_to @user_form, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user_form = UserForm.new(user: @user, email: @user.email)
    @user_form.submit(user_params)

    respond_to do |format|
      if @user_form.save
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :gender, email_attributes: [:address])
    end
end
