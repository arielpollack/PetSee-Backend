class RacesController < ApplicationController
#	before_action :authenticate

	def index
		query = params[:query] || ""
		@races = Race.where("name like ?", "%#{query}%").order(:name)
	end

	def create
		if !params[:race].present?
			render_errors(["race not found"]) 
			return
		end

		race = Race.new(race_params)
		if race.valid? && race.save
			render 'races/_race', :locals => {:race => race}
		else
			render_errors(race.errors)
		end
	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(:name, :image, :about)
    end
end
