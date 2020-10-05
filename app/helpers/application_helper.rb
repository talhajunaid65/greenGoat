module ApplicationHelper
  def roles
    roles_hash = {}
    User::ROLES.each do |role|
      roles_hash[role] = role
    end
    roles_hash
  end
end
