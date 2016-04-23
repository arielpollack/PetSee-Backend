class Service < ActiveRecord::Base
	belongs_to :client
	belongs_to :pet
	belongs_to :service_provider
	has_many :service_requests


	self.inheritance_column = nil
end
