class UsersController < ApplicationController
  before_action :authenticate

  # GET /user
  def index
  end

  # GET /users/1
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        render
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user
  def update
    respond_to do |format|
      if @user.update(user_params)
        render
      else
        render :json => {:has_erors=>"true", :errors => @user.errors, :user => @user}, :status => :unprocessable_entity
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :name)
    end
end
