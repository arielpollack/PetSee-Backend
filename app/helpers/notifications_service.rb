require 'houston'

NOTIFICATION_TYPE = {
    request_your_service: 1,
    approved_your_request: 2,
    confirmed_you_as_provider: 3,

    service_started: 4,
    service_ended: 5,
    service_cancelled: 6
}

class NotificationsService

    APN = Houston::Client.development
    APN.certificate = File.read(File.join(Rails.root, 'lib', 'petsee-push-cert.pem'))

    def self.send_notification(origin_user, destination_user, type, object_id)
        return unless (token = destination_user.device_push_token)

        # increase badge count
        destination_user.notifications_badge_count += 1
        destination_user.save

        notification_text = text_for_type(type, origin_user)

        notification = Notification.new({
                                            :user_id => destination_user.id,
                                            :text => notification_text,
                                            :notification_type => type,
                                            :object_id => object_id
                                        })
        notification.save

        apns_notification = Houston::Notification.new(device: token)
        apns_notification.alert = notification_text
        apns_notification.sound = "default"
        apns_notification.badge = destination_user.notifications_badge_count
        apns_notification.content_available = true
        apns_notification.custom_data = {t: type, o: object_id}

        APN.push(apns_notification)
    end

    private
    def self.text_for_type(type, user)
        case type
            when NOTIFICATION_TYPE[:request_your_service]
                "#{user.name} asked for your service!"
            when NOTIFICATION_TYPE[:approved_your_request]
                "#{user.name} has approved your service!"
            when NOTIFICATION_TYPE[:confirmed_you_as_provider]
                "#{user.name} has confirmed you for his service!"
            when NOTIFICATION_TYPE[:service_started]
                "Your service has started!"
            when NOTIFICATION_TYPE[:service_ended]
                "Your service has ended"
            when NOTIFICATION_TYPE[:service_cancelled]
                "#{user.name} has cancelled the service!"
            else
                nil
        end
    end
end