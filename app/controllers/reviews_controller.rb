class ReviewsController < ApplicationController
  before_action :authenticate

  # GET /reviews
  def index
    last_index = params[:last_index] || 0
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rate, :feedback, :user_id, :writer_id)
    end
end
