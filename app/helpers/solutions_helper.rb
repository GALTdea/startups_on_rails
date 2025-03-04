module SolutionsHelper
  def solution_type_badge_class(solution_type)
    case solution_type&.downcase
    when "product"
      "bg-blue-100 text-blue-800"
    when "service"
      "bg-green-100 text-green-800"
    when "platform"
      "bg-purple-100 text-purple-800"
    when "tool"
      "bg-yellow-100 text-yellow-800"
    when "framework"
      "bg-indigo-100 text-indigo-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
