module ProjectsHelper
  def type_of_projects
    Project.type_of_projects.map { |key, _| [type_text(key), key] }
  end

  def type_text(type)
    {
      "gut" => "Gut Renovation",
      "full" => "Complete Demolition",
      "kitchen" => "Kitchen/Bath Renovation",
      "other" => "Other"
    }[type]
  end
end
