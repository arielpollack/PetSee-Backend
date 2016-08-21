json.array! @locations do |location|
	json.partial! 'services/location', :location => location
end