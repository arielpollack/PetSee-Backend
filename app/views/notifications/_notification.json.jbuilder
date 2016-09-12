json.extract! notification, :id, :text, :type

json.created_at notification.created_at.to_s
json.object case notification.type
            when NOTIFICATION_TYPE[:request_your_service], NOTIFICATION_TYPE[:approved_your_request]
                ServiceRequest.find_by_id(notification.object_id)
            else
                Service.find_by_id(notification.object_id)
            end