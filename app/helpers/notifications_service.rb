require 'houston'

class NotificationsService

    APN = Houston::Client.development
    APN.certificate = File.read(File.join(Rails.root, 'lib', 'petsee-push-cert.pem'))

    TYPES = {
        request_your_service: 1,
        approved_your_request: 2,
        confirmed_you_as_provider: 3,

        service_started: 4,
        service_ended: 5,
        service_cancelled: 6
    }

    def self.send_notification(originUser, destinationUser, type)
        return unless (token = destinationUser.device_push_token)

        # increase badge count
        destinationUser.notifications_badge_count += 1
        destinationUser.save

        notification = Houston::Notification.new(device: token)
        notification.alert = text_for_type(originUser, type)
        notification.badge = destinationUser.notifications_badge_count
        notification.content_available = true
        notification.custom_data = {t: type}

        APN.push(notification)
    end

    private
    def self.text_for_type(type, user)
        case type
            when TYPES[:request_your_service]
                "#{user.name} asked for your service!"
            when TYPES[:approved_your_request]
                "#{user.name} has approved your service!"
            when TYPES[:confirmed_you_as_provider]
                "#{user.name} has confirmed you for his service!"
            when TYPES[:service_started]
                "Your service has started!"
            when TYPES[:service_ended]
                "Your service has ended"
            when TYPES[:service_cancelled]
                "#{user.name} has cancelled the service!"
            else
                nil
        end
    end
end