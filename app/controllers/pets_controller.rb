	class PetsController < ApplicationController
	before_action :authenticate

	def index
		user_id = params[:user_id] || @current_user.id
		@pets = Pet.includes(:race).where(owner_id: user_id)
#   @pets = Pet.all
	end

	def create
		p = pet_params
		p[:owner_id] = @current_user.id
		render_error "race not defined" and return if p[:race_id].nil?
		pet = Pet.new(p)
		if pet.save
			render 'pets/_pet', :locals => {:pet => pet}
		else
			render :json => {:has_erors => true, :errors => pet.errors}, :status => :unprocessable_entity
		end
	end

	def update 
		pet = Pet.where(id: pet_params[:id])
		render_error "pet not found" and return if pet.nil?
		pet.update(pet_params)
		if pet.save
			render 'pets/_pet', :locals => {:pet => pet}
		else
			render :json => {:has_erors => true, :errors => pet.errors}, :status => :unprocessable_entity
		end
	end

	# GET /pets/all
	# Get all the pets

	def showAllPets
		render :json => Pet.all

	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pet_params
      params.require(:pet).permit(:name, :race_id, :color, :about, :is_trained, :image, :birthday)
    end
end
