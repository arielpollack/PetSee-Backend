class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :name
      t.references :race, index: true, foreign_key: true
      t.string :color
      t.text :about, limit: 255
      t.string :image
      t.references :owner, index: true, foreign_key: true
      t.boolean :is_trained
      t.date :birthday

      t.timestamps null: false
    end
  end
end
