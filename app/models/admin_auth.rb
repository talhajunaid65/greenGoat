class AdminAuth < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    case subject
    when normalized(AdminUser)
      if user.admin?
        true
      else
        false
      end
    when normalized(Sale)
      if action == :destroy
        user.admin?
      else
        user.admin? || user.project_manager? ? true : false
      end
    else
      true
    end
  end
end
