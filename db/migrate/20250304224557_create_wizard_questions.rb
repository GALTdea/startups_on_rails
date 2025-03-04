class CreateWizardQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_questions do |t|
      t.string :text, null: false
      t.text :help_text
      t.string :question_type, null: false
      t.integer :position, default: 0
      t.boolean :required, default: true
      t.integer :parent_id
      t.string :dependent_value
      t.string :identifier, null: false

      t.timestamps
    end

    add_index :wizard_questions, :identifier, unique: true
    add_index :wizard_questions, :position
    add_index :wizard_questions, :parent_id
  end
end
