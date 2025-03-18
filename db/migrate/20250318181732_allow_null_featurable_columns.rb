class AllowNullFeaturableColumns < ActiveRecord::Migration[8.0]
  def change
    change_column_null :featured_listings, :featurable_type, true
    change_column_null :featured_listings, :featurable_id, true
  end
end
