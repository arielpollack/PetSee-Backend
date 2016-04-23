json.extract! user, :id, :email, :token, :name, :created_at, :updated_at
json.pets do
	json.array! user.pets do |pet|
		json.partial! 'pets/pet', :pet => pet
	end
end