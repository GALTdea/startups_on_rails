class CreateWizardResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_responses do |t|
      t.references :wizard_session, null: false, foreign_key: true
      t.references :wizard_question, null: false, foreign_key: true
      t.text :response_value

      t.timestamps
    end
  end
end
