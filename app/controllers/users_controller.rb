class UsersController < ApplicationController
    before_action :authenticate

    # GET /users
    def index
        @with_token = true
    end

    # GET /users/:user_id
    def show
        user = User.find_by_id(params[:user_id])
        render_not_found "user not found" and return if user.nil?
        render 'users/_user', :locals => {:user => user}
    end

    # GET users/all
    # return all the users
    def all
        #render :json => User.all
        @users = User.all
    end


    # PATCH/PUT /user
    def update
        # respond_to do |format|
        @current_user.update(user_params)
        @with_token = true
        if @current_user.save
            render 'users/_user', :locals => {:user => @current_user}
        else
            render :json => {:has_errors => "true", :errors => @user.errors, :user => @user}, :status => :unprocessable_entity
        end
        # end
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
        params.permit(:email, :password, :name, :image, :about)
    end
end

