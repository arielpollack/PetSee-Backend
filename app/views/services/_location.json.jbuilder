json.extract! location, :latitude, :longitude

json.timestamp location.created_at.to_i

unless location.street_address.nil?
    json.address location.street_address
end