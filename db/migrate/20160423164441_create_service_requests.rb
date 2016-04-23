class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.references :service, index: true, foreign_key: true
      t.references :service_provider, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
