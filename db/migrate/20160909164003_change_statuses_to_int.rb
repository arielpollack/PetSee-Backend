class ChangeStatusesToInt < ActiveRecord::Migration
    def change
        change_column :service_requests, :status, :integer
        change_column :services, :status, :integer
        change_column :services, :type, :integer
    end
end
