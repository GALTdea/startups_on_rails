class CreateJoinTableCompaniesTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_join_table :companies, :technologies do |t|
      t.index [ :company_id, :technology_id ], unique: true
      t.index [ :technology_id, :company_id ]
    end
  end
end
