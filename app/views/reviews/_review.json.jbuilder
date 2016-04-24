json.extract! review, :id, :rate, :feedback, :created_at, :updated_at
json.writer do
	json.partial! 'users/user', :user => review.writer
end