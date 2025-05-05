class AddSimpleMetadataToSolutions < ActiveRecord::Migration[8.0]
  def change
    add_column :solutions, :target_audience, :string, comment: "Primary user persona (Technical, Non-technical, Marketing, etc.)"
    add_column :solutions, :technical_complexity, :string, comment: "Implementation difficulty (No-code, Low-code, Technical)"
    add_column :solutions, :support_level, :string, comment: "Level of support provided (Self-service, Email/chat, etc.)"
    add_column :solutions, :geographical_availability, :string, default: "Global", comment: "Regions where the solution is available"
    add_column :solutions, :customer_size, :string, comment: "Ideal company size for the solution"

    # Add indexes for faster filtering
    add_index :solutions, :target_audience
    add_index :solutions, :technical_complexity
    add_index :solutions, :support_level
    add_index :solutions, :geographical_availability
    add_index :solutions, :customer_size
  end
end
