class AddPushTokenToUsers < ActiveRecord::Migration
    def change
        add_column :users, :device_push_token, :string
        add_column :users, :notifications_badge_count, :integer, default: 0
    end
end
