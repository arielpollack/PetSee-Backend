class UsersController < ApplicationController
  before_action :authenticate

  # GET /users
  def index
    @with_token = true
  end

  # GET /users/:user_id
  def show
    render :json => User.find(params[:user_id])
  end

  # GET users/all
  # return all the users
  def all
    #render :json => User.all
    @users = User.all
  end

  # PATCH/PUT /user
  def update
    respond_to do |format|
      if @user.update(user_params)
        render
      else
        render :json => {:has_errors=>"true", :errors => @user.errors, :user => @user}, :status => :unprocessable_entity
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :name)
    end
end
