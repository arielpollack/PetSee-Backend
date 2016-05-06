json.cache! service do
    json.extract! service, :id, :created_at, :updated_at, :time_start, :time_end, :status, :type
    json.pet do
        json.partial! 'pets/pet', :pet => service.pet
    end
end

if @with_client
    json.client do
        json.partial! 'users/user', :user => service.client
    end
end
if @with_service_provider && service.service_provider
    json.service_provider do
        json.partial! 'users/user', :user => service.service_provider
    end
end