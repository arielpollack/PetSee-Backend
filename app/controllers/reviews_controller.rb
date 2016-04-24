class ReviewsController < ApplicationController
  before_action :authenticate

  # GET /reviews
  def index
    last_index = params[:last_index]
    @reviews = Review.includes(:writer).where(user_id: params[:user_id]).where("id > ?", last_index)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rate, :feedback, :user_id, :writer_id)
    end
end
