json.extract! review, :id, :rate, :details, :created_at, :updated_at
json.user do
	json.partial! 'users/user', :user => review.user
end
json.writer do
	json.partial! 'users/user', :user => review.writer
end