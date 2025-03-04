class PopulateCompanyIndustries < ActiveRecord::Migration[8.0]
  def up
    # Define the available industries that match the dropdown options in the view
    industries = [ "tech", "healthcare", "finance", "education", "retail" ]

    # Get all companies that don't have an industry
    Company.where(industry: [ nil, "" ]).find_each do |company|
      # Assign a random industry
      company.update_column(:industry, industries.sample)
    end

    # Output a summary
    puts "Updated #{Company.where.not(industry: [ nil, '' ]).count} companies with industries"
  end

  def down
    # Revert changes by clearing all industry values
    Company.update_all(industry: nil)
  end
end
