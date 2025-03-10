class AddCompanyToSolutions < ActiveRecord::Migration[8.0]
  def change
    add_reference :solutions, :company, null: true, foreign_key: true
  end
end
