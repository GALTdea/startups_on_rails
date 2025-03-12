module CategoriesHelper
  def category_breadcrumb(category, options = {})
    return "" unless category

    separator = options[:separator] || " / "
    include_self = options.fetch(:include_self, true)

    breadcrumb_items = category.ancestors.map do |ancestor|
      if options[:linked]
        link_to ancestor.name, options[:path_helper].call(ancestor), class: options[:link_class]
      else
        content_tag(:span, ancestor.name, class: options[:item_class])
      end
    end

    if include_self
      if options[:linked] && options[:self_linked]
        breadcrumb_items << link_to(category.name, options[:path_helper].call(category), class: options[:link_class])
      else
        breadcrumb_items << content_tag(:span, category.name, class: options[:current_class] || options[:item_class])
      end
    end

    safe_join(breadcrumb_items, separator)
  end

  def category_select_options(category_type = nil)
    categories = if category_type
                   Category.where(category_type: category_type)
    else
                   Category.all
    end

    categories.roots.flat_map do |root|
      [ root.name, root.id ] + nested_category_options(root.children)
    end
  end

  private

  def nested_category_options(categories, level = 1)
    categories.flat_map do |category|
      indent = "—" * level
      [ [ " #{indent} #{category.name}", category.id ] ] + nested_category_options(category.children, level + 1)
    end
  end
end
