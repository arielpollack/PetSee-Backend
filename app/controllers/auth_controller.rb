require 'digest/sha1'

class AuthController < ApplicationController

	VALID_TYPES = [Client.name, ServiceProvider.name]
	def signup
		render_error "params not valid", :not_acceptable and return unless auth_params.permitted?
		render_error "email and password required", :not_acceptable and return unless params[:email].present? && params[:password].present?
		render_error "type not defined" and return unless params[:type].present?
		render_error "type not valid" and return unless VALID_TYPES.include?(params[:type])
		render_error "email already exist" and return unless user_with_email(params[:email]).nil?
		enc_password = Digest::SHA1.hexdigest "#{params[:password]}"
		params[:password] = enc_password
		@user = User.new(auth_params)
		render_error "failed save" and return unless @user.save
		@with_token = true
		render 'users/_user', :locals => {:user => @user}
	end

	def login
		render_error "params not valid", :not_acceptable and return unless auth_params.permitted?
		render_error "email and password required", :not_acceptable and return unless params[:email].present? && params[:password].present?
		@user = user_with_email(params[:email])
		render_error "email not exist", :not_found and return if @user.nil?
		enc_password = Digest::SHA1.hexdigest "#{params[:password]}"
		render_error "password dosn't match" and return unless enc_password.to_s == @user.password
		@with_token = true
		render 'users/_user', :locals => {:user => @user}
	end

	def is_email_exist
		render :json => {:email_exist => !user_with_email(params[:email]).nil?}
	end

	private 
	def render_error(error, status = :unprocessable_entity)
		render :json => {:error => error}, :status => status
	end
	def user_with_email(email)
		User.find_by(email: email.downcase)
	end
	def auth_params
		params.permit(:email, :password, :name, :type)
	end
end
