class ServiceProvider < User
	has_many :services
	has_many :service_requests
end
