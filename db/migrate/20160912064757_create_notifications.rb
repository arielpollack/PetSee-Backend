class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :text
      t.references :user, index: true, foreign_key: true
      t.integer :notification_type
      t.integer :object_id

      t.timestamps null: false
    end
  end
end
