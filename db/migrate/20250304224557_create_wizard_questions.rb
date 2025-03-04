class CreateWizardQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_questions do |t|
      t.string :text
      t.text :help_text
      t.string :question_type
      t.integer :position
      t.boolean :required
      t.integer :parent_id
      t.string :dependent_value

      t.timestamps
    end
  end
end
