json.pets @pets do |pet|
	json.partial! 'pets/pet', :pet => pet
end
json.total @pets.count