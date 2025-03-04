class AddCompanyToSolutions < ActiveRecord::Migration[8.0]
  def change
    add_reference :solutions, :company, null: false, foreign_key: true
  end
end
