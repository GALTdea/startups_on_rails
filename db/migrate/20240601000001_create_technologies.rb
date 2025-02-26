class CreateTechnologies < ActiveRecord::Migration[7.1]
  def change
    create_table :technologies do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.integer :popularity, default: 0
      t.string :logo_url

      t.timestamps
    end

    add_index :technologies, :name, unique: true
    add_index :technologies, :category
    add_index :technologies, :popularity
  end
end
