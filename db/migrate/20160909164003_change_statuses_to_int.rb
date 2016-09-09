class ChangeStatusesToInt < ActiveRecord::Migration
    def change
        change_column :service_requests, :status, :integer, default: 0
        change_column :services, :status, :integer, default: 0
        change_column :services, :type, :integer, default: 0
    end
end
