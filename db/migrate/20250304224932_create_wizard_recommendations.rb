class CreateWizardRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_recommendations do |t|
      t.references :wizard_session, null: false, foreign_key: true
      t.references :solution, null: false, foreign_key: true
      t.decimal :score
      t.text :reasoning

      t.timestamps
    end
  end
end
