Gretel::Crumbs.layout do
  crumb :root do
    link "Home", root_path
  end

  crumb :about do
    link "About", about_path
  end

  crumb :about_with_root do
    link "About with parent set to root", about_path
    parent :root
  end

  crumb :about_without_root do
    link "About without parent set to root", about_path
  end

  crumb :projects do
    link "Projects", projects_path
  end

  crumb :project do |project|
    link project.name, project_path(project)
  end

  crumb :project_with_autopath do |project|
    link project.name, project
  end

  crumb :project_with_parent do |project|
    link project.name, project
    parent :projects
  end

  crumb :issue_with_parent_project do |issue|
    link issue.title, project_issue_path(issue.project, issue)
    parent :project, issue.project
  end

  crumb :contact_form do
    link "Contact", contact_path
    link "Contact form", contact_form_path
  end

  crumb :contact_form_originating_from_about do
    link "Contact", contact_path
    link "Contact form", contact_form_path
    parent :about
  end

  
  # crumb :projects do
  #   link "Projects", projects_path
  # end
  
  # crumb :project do |project|
  #   link lambda { |project| "#{project.name} (#{project.id.to_s})" }, project_path(project)
  #   parent :projects
  # end
  
  # crumb :project_issues do |project|
  #   link "Issues", project_issues_path(project)
  #   parent :project, project
  # end
  
  # crumb :issue do |issue|
  #   link issue.name, issue_path(issue)
  #   parent :project_issues, issue.project
  # end

end