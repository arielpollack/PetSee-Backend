json.array! @races do |race|
	json.partial! 'races/race', :race => race
end