module ApplicationHelper
  include Pagy::Frontend

  # Render pagination with Tailwind CSS styling
  def tailwind_pagy_nav(pagy)
    return unless pagy.pages > 1

    html = [ '<nav class="flex items-center justify-center mt-8 mb-4" aria-label="Pagination">' ]
    html << '<ul class="inline-flex -space-x-px">'

    # Previous link
    if pagy.prev
      html << %(<li>#{link_to '<span class="sr-only">Previous</span><svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg>'.html_safe, pagy_url_for(pagy, pagy.prev), class: "flex items-center justify-center px-3 h-10 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700"}</li>)
    else
      html << %(<li><span class="flex items-center justify-center px-3 h-10 ms-0 leading-tight text-gray-300 bg-white border border-e-0 border-gray-200 rounded-s-lg cursor-not-allowed"><span class="sr-only">Previous</span><svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg></span></li>)
    end

    # Page links
    pagy.series.each do |item|
      html << case item
      when Integer
        # Page link
        %(<li>#{link_to item, pagy_url_for(pagy, item), class: "flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700"}</li>)
      when :gap
        # Gap
        %(<li><span class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300">…</span></li>)
      when :current
        # Current page
        %(<li><span class="flex items-center justify-center px-3 h-10 text-blue-600 border border-gray-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700">#{item}</span></li>)
      end
    end

    # Next link
    if pagy.next
      html << %(<li>#{link_to '<span class="sr-only">Next</span><svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>'.html_safe, pagy_url_for(pagy, pagy.next), class: "flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700"}</li>)
    else
      html << %(<li><span class="flex items-center justify-center px-3 h-10 leading-tight text-gray-300 bg-white border border-gray-200 rounded-e-lg cursor-not-allowed"><span class="sr-only">Next</span><svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg></span></li>)
    end

    html << "</ul></nav>"
    html.join.html_safe
  end
end
