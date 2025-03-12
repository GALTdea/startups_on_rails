class CreateTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :technologies do |t|
      t.string :name
      t.string :category
      t.integer :popularity
      t.string :logo_url

      t.timestamps
    end

    add_index :technologies, :name, unique: true
  end
end
