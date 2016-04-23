class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :token
      t.string :name
      t.string :phone, limit: 13
      t.string :type
      t.references :location, index: true, foreign_key: true
      t.text :about, limit: 255
      t.string :image
      t.decimal :rating, precision: 2, scale: 2, default: 0.0
      t.integer :rating_count, default: 0

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :token
  end
end
