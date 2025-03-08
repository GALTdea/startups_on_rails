class RevertWizardAndSolutionCategoriesFeatures < ActiveRecord::Migration[7.1]
  def up
    # Drop tables in reverse order to handle dependencies

    # First drop wizard_recommendations table which depends on wizard_sessions
    drop_table :wizard_recommendations if table_exists?(:wizard_recommendations)

    # Then drop wizard responses table (depends on wizard sessions and wizard options)
    drop_table :wizard_responses if table_exists?(:wizard_responses)

    # Then drop wizard sessions table
    drop_table :wizard_sessions, force: :cascade if table_exists?(:wizard_sessions)

    # Drop wizard options (depends on wizard questions)
    drop_table :wizard_options, force: :cascade if table_exists?(:wizard_options)

    # Drop wizard questions
    drop_table :wizard_questions, force: :cascade if table_exists?(:wizard_questions)

    # Drop solution_categories_solutions join table
    drop_table :solution_categories_solutions, force: :cascade if table_exists?(:solution_categories_solutions)

    # Drop solutions table (if needed)
    drop_table :solutions, force: :cascade if table_exists?(:solutions)

    # Finally drop solution_categories
    drop_table :solution_categories, force: :cascade if table_exists?(:solution_categories)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot restore dropped tables. Please use the original migrations to recreate these tables."
  end

  private

  def table_exists?(table_name)
    ActiveRecord::Base.connection.table_exists?(table_name)
  end
end
