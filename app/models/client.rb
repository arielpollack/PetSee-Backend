class Client < User
	has_many :pets, :foreign_key => 'owner_id'
	has_many :services
	has_many :service_requests, through: :services
end
