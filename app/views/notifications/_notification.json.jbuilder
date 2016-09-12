json.extract! notification, :id, :text, :read

json.created_at notification.created_at.to_s
json.type notification.notification_type
json.object case notification.notification_type
            when NOTIFICATION_TYPE[:request_your_service], NOTIFICATION_TYPE[:approved_your_request]
                ServiceRequest.find_by_id(notification.object_id)
            else
                Service.find_by_id(notification.object_id)
            end