class CreateWizardOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_options do |t|
      t.references :wizard_question, null: false, foreign_key: true
      t.string :text
      t.string :value
      t.integer :position

      t.timestamps
    end
  end
end
