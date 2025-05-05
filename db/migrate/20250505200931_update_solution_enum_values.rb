class UpdateSolutionEnumValues < ActiveRecord::Migration[8.0]
  def up
    # Map old enum values to new ones
    mapping = {
      # Target audience
      "technical_users" => "audience_technical_users",
      "non_technical_users" => "audience_non_technical_users",
      "marketing_teams" => "audience_marketing_teams",
      "operations_teams" => "audience_operations_teams",
      "hr_admin_teams" => "audience_hr_admin_teams",
      "legal_compliance_teams" => "audience_legal_compliance_teams",
      "general_entrepreneurs" => "audience_general_entrepreneurs",

      # Technical complexity
      "no_code" => "complexity_no_code",
      "low_code" => "complexity_low_code",
      "technical" => "complexity_technical",

      # Support level
      "self_service" => "support_self_service",
      "email_chat" => "support_email_chat",
      "dedicated_account" => "support_dedicated_account",
      "enterprise_support" => "support_enterprise_support",

      # Geographical availability
      "global" => "geo_global",
      "north_america" => "geo_north_america",
      "europe" => "geo_europe",
      "asia_pacific" => "geo_asia_pacific",
      "latin_america" => "geo_latin_america",
      "custom_regions" => "geo_custom_regions",

      # Customer size
      "solo" => "size_solo",
      "startup" => "size_startup",
      "small" => "size_small",
      "medium" => "size_medium",
      "large" => "size_large",
      "enterprise" => "size_enterprise"
    }

    # Update all columns with a conditional update for each mapping
    mapping.each do |old_value, new_value|
      execute <<-SQL
        UPDATE solutions
        SET target_audience = '#{new_value}'
        WHERE target_audience = '#{old_value}';

        UPDATE solutions
        SET technical_complexity = '#{new_value}'
        WHERE technical_complexity = '#{old_value}';

        UPDATE solutions
        SET support_level = '#{new_value}'
        WHERE support_level = '#{old_value}';

        UPDATE solutions
        SET geographical_availability = '#{new_value}'
        WHERE geographical_availability = '#{old_value}';

        UPDATE solutions
        SET customer_size = '#{new_value}'
        WHERE customer_size = '#{old_value}';
      SQL
    end
  end

  def down
    # Map new enum values to old ones
    mapping = {
      # Target audience
      "audience_technical_users" => "technical_users",
      "audience_non_technical_users" => "non_technical_users",
      "audience_marketing_teams" => "marketing_teams",
      "audience_operations_teams" => "operations_teams",
      "audience_hr_admin_teams" => "hr_admin_teams",
      "audience_legal_compliance_teams" => "legal_compliance_teams",
      "audience_general_entrepreneurs" => "general_entrepreneurs",

      # Technical complexity
      "complexity_no_code" => "no_code",
      "complexity_low_code" => "low_code",
      "complexity_technical" => "technical",

      # Support level
      "support_self_service" => "self_service",
      "support_email_chat" => "email_chat",
      "support_dedicated_account" => "dedicated_account",
      "support_enterprise_support" => "enterprise_support",

      # Geographical availability
      "geo_global" => "global",
      "geo_north_america" => "north_america",
      "geo_europe" => "europe",
      "geo_asia_pacific" => "asia_pacific",
      "geo_latin_america" => "latin_america",
      "geo_custom_regions" => "custom_regions",

      # Customer size
      "size_solo" => "solo",
      "size_startup" => "startup",
      "size_small" => "small",
      "size_medium" => "medium",
      "size_large" => "large",
      "size_enterprise" => "enterprise"
    }

    # Update all columns with a conditional update for each mapping
    mapping.each do |new_value, old_value|
      execute <<-SQL
        UPDATE solutions
        SET target_audience = '#{old_value}'
        WHERE target_audience = '#{new_value}';

        UPDATE solutions
        SET technical_complexity = '#{old_value}'
        WHERE technical_complexity = '#{new_value}';

        UPDATE solutions
        SET support_level = '#{old_value}'
        WHERE support_level = '#{new_value}';

        UPDATE solutions
        SET geographical_availability = '#{old_value}'
        WHERE geographical_availability = '#{new_value}';

        UPDATE solutions
        SET customer_size = '#{old_value}'
        WHERE customer_size = '#{new_value}';
      SQL
    end
  end
end
