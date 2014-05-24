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
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(user: @user, email: @email)
  end

  # GET /users/1/edit
  def edit
    @user_form = UserForm.new(user: @user, email: @user.email)
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(user: @user, email: @email)
    @user_form.submit(user_params)

    respond_to do |format|
      if @user_form.valid?
        @user_form.save
        format.html { redirect_to @user_form, notice: "User: #{@user.name} was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user_form = UserForm.new(user: @user, email: @user.email)
    @user_form.submit user_params

    respond_to do |format|
      if @user_form.valid?
        @user_form.save
        format.html { redirect_to @user_form, notice: "User: #{@user.name} was successfully updated." }
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
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :gender, :address)
    end
end
