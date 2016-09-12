class NotificationsController < ApplicationController

    before_action :authenticate

    def index
        @notifications = Notification.where(user_id: @current_user.id).order(created_at: "desc")
    end

    def read
        render_not_found "notification not exist" and return unless notification = Notification.find_by_id(params[:notification_id])
        notification.read = true
        render_success and return if notification.save
        render_error "couldn't save", 400
    end

    def read_all
        Notification.where(user_id: @current_user.id, read: false).update_all(read: true)
    end
end
