class AddAddressToLocations < ActiveRecord::Migration
    def change
        add_column :locations, :street_address, :string
    end
end
