class SetDefaultCategoryTypeForExistingCategories < ActiveRecord::Migration[8.0]
  def up
    # Set a default category_type of 'industry' for all existing categories
    execute <<-SQL
      UPDATE categories
      SET category_type = 'industry'
      WHERE category_type IS NULL OR category_type = '';
    SQL
  end

  def down
    # No need to revert this as it's a data migration
  end
end
