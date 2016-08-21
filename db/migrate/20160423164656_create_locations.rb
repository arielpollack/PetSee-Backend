class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
	  t.references :service, index: true, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
