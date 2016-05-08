json.extract! pet, :name, :id, :color, :about, :image, :is_trained
json.race do
	json.partial! 'races/race', :race => pet.race
end 