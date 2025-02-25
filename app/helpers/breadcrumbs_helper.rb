module BreadcrumbsHelper
  # Generate a breadcrumb item
  # @param text [String] The text to display
  # @param url [String] The URL to link to (nil for current page)
  # @param options [Hash] Additional options
  # @option options [Boolean] :active Whether this is the active/current page
  # @return [String] HTML for the breadcrumb item
  def breadcrumb_item(text, url = nil, options = {})
    active = options.fetch(:active, url.nil?)

    content_tag(:li, class: active ? "inline-flex items-center" : "inline-flex items-center") do
      if active
        # Current page (not a link)
        content_tag(:span, text, class: "text-sm font-medium text-gray-500 md:ml-2")
      else
        # Link to another page
        link_to(url, class: "inline-flex items-center text-sm font-medium text-gray-500 hover:text-blue-600 md:ml-2") do
          raw('<svg class="w-6 h-6 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>') +
          text
        end
      end
    end
  end

  # Generate breadcrumbs for a resource
  # @param resource [ActiveRecord::Base] The resource to generate breadcrumbs for
  # @param parent_resources [Array<ActiveRecord::Base>] Parent resources (optional)
  # @return [String] HTML for the breadcrumbs
  def resource_breadcrumbs(resource, parent_resources = [])
    crumbs = []

    # Add parent resources
    parent_resources.each do |parent|
      crumbs << breadcrumb_item(
        parent.class.model_name.human,
        url_for(controller: parent.class.name.underscore.pluralize, action: :index)
      )

      crumbs << breadcrumb_item(
        parent.respond_to?(:name) ? parent.name : "#{parent.class.model_name.human} ##{parent.id}",
        url_for(parent)
      )
    end

    # Add resource index
    crumbs << breadcrumb_item(
      resource.class.model_name.human.pluralize,
      url_for(controller: resource.class.name.underscore.pluralize, action: :index)
    )

    # Add resource itself (if it's persisted)
    if resource.persisted?
      crumbs << breadcrumb_item(
        resource.respond_to?(:name) ? resource.name : "#{resource.class.model_name.human} ##{resource.id}",
        nil,
        active: true
      )
    else
      crumbs << breadcrumb_item("New #{resource.class.model_name.human}", nil, active: true)
    end

    safe_join(crumbs)
  end
end
