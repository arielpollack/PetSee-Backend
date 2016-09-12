class AddHourlyRateToUsers < ActiveRecord::Migration
    def change
        add_column :users, :hourly_rate, :integer, default: 0
    end
end
