class FixUserRating < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.change :rating, :decimal, precision: 2, scale: 1
    end
  end
end
