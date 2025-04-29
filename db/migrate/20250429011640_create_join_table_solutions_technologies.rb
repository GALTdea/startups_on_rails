class CreateJoinTableSolutionsTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_join_table :solutions, :technologies do |t|
      t.index [ :solution_id, :technology_id ], unique: true
      t.index [ :technology_id, :solution_id ]
    end
  end
end
