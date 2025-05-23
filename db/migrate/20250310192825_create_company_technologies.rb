class CreateCompanyTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :company_technologies do |t|
      t.references :company, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true
      t.string :proficiency_level

      t.timestamps
    end

    add_index :company_technologies, [ :company_id, :technology_id ], unique: true
  end
end
