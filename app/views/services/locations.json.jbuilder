json.array! @locations do |location|
	json.latitude location.latitude
	json.longitude location.longitude
	json.timestamp location.created_at.to_i
end