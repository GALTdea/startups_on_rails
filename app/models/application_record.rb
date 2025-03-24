# Base abstract class that all application models inherit from.
# Serves as the foundation for all models in the application and allows for
# shared behavior across models without modifying ActiveRecord::Base directly.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
