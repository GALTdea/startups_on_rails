class CreateWizardSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_identifier
      t.boolean :completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
