class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rate, limit: 2
      t.text :feedback, limit: 255
      t.references :user, index: true, foreign_key: true
      t.references :writer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
