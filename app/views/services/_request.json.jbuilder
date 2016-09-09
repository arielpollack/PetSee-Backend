json.extract! request, :id, :created_at, :updated_at, :status, :service
if @with_service
	json.service do
		json.partial! 'services/service', :service => request.service
	end
end
if @with_provider
	json.service_provider do
	    json.partial! 'users/user', :user => request.service_provider
	end
end