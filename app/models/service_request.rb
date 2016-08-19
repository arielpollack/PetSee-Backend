class ServiceRequest < ActiveRecord::Base
  belongs_to :service
  belongs_to :service_provider
  belongs_to :client

  enum status: [ :pending, :approved, :denied ]
end
