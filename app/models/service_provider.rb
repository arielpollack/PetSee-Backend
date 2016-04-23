class ServiceProvider < User
	has_many :skills, :class_name => 'ServiceProviderSkill'
	has_many :services
	has_many :service_requests
end
