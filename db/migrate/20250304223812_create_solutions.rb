class CreateSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solutions do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :pricing
      t.string :deployment_type
      t.integer :popularity
      t.string :solution_type

      t.timestamps
    end
  end
end
