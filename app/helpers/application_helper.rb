module ApplicationHelper
  def roles
    roles_hash = {}
    User::ROLES.each do |role|
      roles_hash[role] = role
    end
    roles_hash
  end

  def image_variant(image, width=40, height=40)
    if image.variable?
      image.variant(combine_options: { resize: "#{width}x#{height}^", extent: "#{width}x#{height}", gravity: 'center', quality: 100 })
    else
      image
    end
  end
end
