class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.string :about
      t.string :image

      t.timestamps null: false
    end
    add_index :races, :name, unique: true
  end
end
