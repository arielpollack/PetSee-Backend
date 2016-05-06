json.array! @pets do |pet|
	json.partial! 'pets/pet', :pet => pet
end