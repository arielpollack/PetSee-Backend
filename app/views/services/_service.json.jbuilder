json.extract! service, :id, :created_at, :updated_at, :status, :type, :service_provider

json.time_start service.time_start.to_i
json.time_end service.time_end.to_i

json.pet do
    json.partial! 'pets/pet', :pet => service.pet
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