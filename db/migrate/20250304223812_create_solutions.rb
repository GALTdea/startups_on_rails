class CreateSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solutions do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :pricing
      t.string :deployment_type
      t.integer :popularity, default: 0
      t.string :solution_type
      t.boolean :published, default: false

      t.timestamps
    end

    add_index :solutions, :name
    add_index :solutions, :solution_type
    add_index :solutions, :deployment_type
    add_index :solutions, :popularity
  end
end
