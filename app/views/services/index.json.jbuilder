json.array! @services do |service|
	json.partial! 'services/service', :service => service
end