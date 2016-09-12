json.extract! user, :id, :name, :type, :email, :image, :about, :rating_count, :created_at, :updated_at
json.rating user.rating.to_f

if user.instance_of?(ServiceProvider)
    json.hourly_rate user.hourly_rate
end

if @with_token
    json.token user.token
end
