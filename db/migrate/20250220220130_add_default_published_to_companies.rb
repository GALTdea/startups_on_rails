class AddDefaultPublishedToCompanies < ActiveRecord::Migration[7.1]
  def change
    change_column_default :companies, :published, from: nil, to: false
  end
end
