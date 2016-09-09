class ReviewsController < ApplicationController
    before_action :authenticate

    # GET /reviews
    # The reviews that other users wrote about current user
    def index
        last_index = params[:last_index] || 0
        Rails.logger.info "user id is: #{params[:user_id]}"
        @reviews = Review.includes(:writer).where(user_id: params[:user_id]).where("id > ?", last_index).limit(20)
        @with_user = false
        @with_writer = true
    end

    # The reviews that current user wrote
    def my_reviews
        last_index = params[:last_index] || 0
        @reviews = Review.includes(:user).where(writer_id: @current_user.id).where("id > ?", last_index).limit(20)
        @with_user = true
        @with_writer = false
        render 'reviews/index'
    end

    # Return a review that current_user wrote on user_id
    def review_about_user
        @reviews = Review.includes(:user).where(writer_id: @current_user.id).where(user_id: params[:user_id])
        @with_user = true
        @with_writer = false
        render 'reviews/index'
    end

    # Create new review
    def create
        r = review_params
        render_error "rate must be between 1 to 5", :render_forbidden and return if not (1..5).include? r[:rate].to_i
        render_error "feedback must contain text", :render_forbidden and return if r[:feedback].nil? || r[:feedback] == ""

        @review = Review.where(writer_id: @current_user.id, user_id: params[:user_id]).first
        Rails.logger.info "IS NEW REVIEW? #{@review.nil?}"

        render_error "You have already written a review about this user", :render_forbidden and return if !@review.nil?

        r[:user_id] = params[:user_id]
        r[:writer_id] = @current_user.id

        @review = Review.new(r)
        @with_user = false
        @with_writer = true
        if @review.save
            render 'reviews/_review', :locals => {:review => @review}
        else
            render :json => {:has_erors => true, :errors => review.errors}, :status => :unprocessable_entity
        end

    end

    def update_existing_review
        @review = Review.where(id: params[:review_id]).first
        render_error "You are not the writer of this review", :render_forbidden and return if not @review.writer_id == @current_user.id
        render_error "There is no review of this number", :render_forbidden and return if @review.nil?

        @review.update(review_params)
        if @review.save
            render 'reviews/_review', :locals => {:review => @review}
        else
            render :json => {:has_erors => "true", :errors => @review.errors, :review => @review}, :status => :unprocessable_entity
        end
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
        params.require(:review).permit(:rate, :feedback, :user_id, :writer_id)
    end

end
