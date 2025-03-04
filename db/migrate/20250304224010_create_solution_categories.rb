class CreateSolutionCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :solution_categories do |t|
      t.string :name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
