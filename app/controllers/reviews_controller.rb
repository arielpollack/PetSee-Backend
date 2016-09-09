class ReviewsController < ApplicationController
    before_action :authenticate

    # GET /reviews
    def index
        last_index = params[:last_index] || 0
        Rails.logger.info "Last index is: #{last_index}"
        @reviews = Review.includes(:writer).where(user_id: params[:user_id]).where("id > ?", last_index).limit(20)
        @with_user = false
        @with_writer = true
    end

    def my_reviews
        last_index = params[:last_index] || 0
        @reviews = Review.includes(:user).where(writer_id: @current_user.id).where("id > ?", last_index).limit(20)
        @with_user = true
        @with_writer = false
        render 'reviews/index'
    end

    # Create new review
    def create
        r = review_params
        render_error "rate must be between 1 to 5" and return if not (1..5).include? r[:rate].to_i
        render_error "feedback must contain text" and return if r[:feedback].nil? || r[:feedback] == ""

        r[:user_id] = params[:user_id]
        r[:writer_id] = @current_user.id

        review = Review.new(r)
        @with_user = false
        @with_writer = true

        if review.save
            render 'reviews/_review', :locals => {:review => review}
        else
            render :json => {:has_erors => true, :errors => review.errors}, :status => :unprocessable_entity
        end

    end


    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
        params.require(:review).permit(:rate, :feedback, :user_id, :writer_id)
    end
end
