json.extract! notification, :id, :text, :read

json.created_at notification.created_at.to_s
json.type notification.notification_type
json.object do
    case notification.notification_type
        when NOTIFICATION_TYPE[:request_your_service], NOTIFICATION_TYPE[:approved_your_request]
            if request = ServiceRequest.find_by_id(notification.object_id)
                json.partial! 'services/request', :request => request
            else
                nil
            end

        else
            if service = Service.find_by_id(notification.object_id)
                json.partial! 'services/service', :service => service
            else
                nil
            end
    end
end