class AddLocationToServices < ActiveRecord::Migration
  def change
    add_reference :services, :location, index: true, foreign_key: true
  end
end
