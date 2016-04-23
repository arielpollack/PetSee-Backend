class Client < User
	has_many :pets
	has_many :services
	has_many :service_requests, through: :services
end
