class CreateSolutionCategoriesSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solution_categories_solutions do |t|
      t.references :solution_category, null: false, foreign_key: true
      t.references :solution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
