class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :client, index: true, foreign_key: true
      t.references :pet, index: true, foreign_key: true
      t.references :service_provider, index: true, foreign_key: true
      t.datetime :time_start
      t.datetime :time_end
      t.integer :status, default: 0, null: false
      t.integer :type, null: false

      t.timestamps null: false
    end
  end
end
