class AddServiceToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :service, index: true, foreign_key: true
  end
end
