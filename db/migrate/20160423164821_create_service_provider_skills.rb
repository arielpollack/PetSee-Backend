class CreateServiceProviderSkills < ActiveRecord::Migration
  def change
    create_table :service_provider_skills do |t|
      t.references :skill, index: true, foreign_key: true
      t.references :service_provider, index: true, foreign_key: true
      t.integer :years_of_experience, limit: 2
      t.text :details, limit: 255

      t.timestamps null: false
    end
  end
end
