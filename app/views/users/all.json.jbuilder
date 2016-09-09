json.users @users do |user|
  json.extract! user, :id, :name, :type, :about, :rating, :rating_count
  json.review do
    # TODO
    # Add review for each user
    # json.partial! 'reviews/review', :user_id => user.id
    # json.array! 'reviews/review', :user_id => user.id
  end
end