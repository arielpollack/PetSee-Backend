json.extract! user, :id, :email, :name, :image, :about, :rating_count, :created_at, :updated_at
json.rating user.rating.to_f

if @with_token
    json.token user.token
end
