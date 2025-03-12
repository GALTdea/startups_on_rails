module Admin::UsersHelper
  def role_badge_class(role)
    case role
    when "admin"
      "px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800"
    when "company_owner"
      "px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800"
    else
      "px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800"
    end
  end
end
