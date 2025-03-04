class CreateSolutionCategoriesSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solution_categories_solutions do |t|
      t.references :solution_category, null: false, foreign_key: true
      t.references :solution, null: false, foreign_key: true

      t.timestamps
    end

    add_index :solution_categories_solutions, [ :solution_category_id, :solution_id ], unique: true, name: 'index_solution_categories_solutions_unique'
  end
end
