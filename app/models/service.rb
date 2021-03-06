class Service < ActiveRecord::Base
	belongs_to :client
	belongs_to :pet
	belongs_to :service_provider
	belongs_to :location
	has_many :service_requests
	has_many :locations

	enum status: [ :pending, :confirmed, :started, :ended ]

	enum type: [ :dogsit, :dogwalk ]


	self.inheritance_column = nil
end
