class CreateJoinTableCompaniesCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :companies, :categories do |t|
      # t.index [:company_id, :category_id]
      # t.index [:category_id, :company_id]
    end
  end
end
