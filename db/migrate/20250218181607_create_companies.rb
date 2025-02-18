class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :website
      t.string :location
      t.string :slug
      t.boolean :published

      t.timestamps
    end
  end
end
