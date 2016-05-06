json.cache! ['v1', review] do
    json.extract! review, :id, :rate, :feedback, :created_at, :updated_at
end

if @with_user
    json.user do
        json.partial! 'users/user', :user => review.user
    end
end
if @with_writer
    json.writer do
        json.partial! 'users/user', :user => review.writer
    end
end