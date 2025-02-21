class AddIndexesToCompaniesTags < ActiveRecord::Migration[8.0]
  def change
    add_index :companies_tags, [ :company_id, :tag_id ], unique: true
    add_index :companies_tags, [ :tag_id, :company_id ], unique: true
  end
end
