# Pagy initializer
# See https://ddnexus.github.io/pagy/api/pagy.html for details

# Load the Pagy::Backend module
require 'pagy/backend'

# Load the Pagy::Frontend module
require 'pagy/frontend'

# Set items per page (default is 20)
Pagy::DEFAULT[:items] = 9 # Show 9 companies per page to match the 3x3 grid layout

# Make Pagy handle Turbo Drive requests by tracking the scroll position
Pagy::DEFAULT[:headers] = { page: 'Current-Page', items: 'Page-Items', count: 'Total-Count', pages: 'Total-Pages' }

# You can overload default calculations
# See https://ddnexus.github.io/pagy/api/pagy.html#instance-variables
# The calculated defaults:
# Pagy::DEFAULT[:size]       = [1,4,4,1]                       # Four pages allowed in the floating pages navigation
# Pagy::DEFAULT[:page_param] = :page                           # The parameter name used in the params
# Pagy::DEFAULT[:params]     = {}                              # Additional custom params to be added to the url

# Enable trim_extra for cleaner links
Pagy::DEFAULT[:trim_extra] = true
