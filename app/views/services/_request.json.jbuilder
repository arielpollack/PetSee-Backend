json.extract! request, :id, :created_at, :updated_at, :status
json.service_provider do
    json.partial! 'users/user', :user => request.service_provider
end