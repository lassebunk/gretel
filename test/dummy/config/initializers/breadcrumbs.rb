Gretel::Crumbs.layout do
  crumb :root do
    link "Home", root_path
  end

  crumb :simple do
    link "About", about_path
  end

  crumb :with_root do
    link "About with parent set to root", about_path
    parent :root
  end

  crumb :without_root do
    link "About without parent set to root", about_path
  end

  crumb :projects do
    link "Projects", projects_path
  end

  crumb :with_autopath do |project|
    link project.name, project
  end

  crumb :with_parent do |project|
    link project.name, project
    parent :projects
  end

  crumb :with_parent_object do |issue|
    link issue.title, project_issue_path(issue.project, issue)
    parent :project, issue.project
  end

  crumb :about do
    link "About", about_path
  end

  crumb :multiple_links do
    link "Contact", contact_path
    link "Contact form", contact_form_path
  end

  crumb :multiple_links_with_parent do
    link "Contact", contact_path
    link "Contact form", contact_form_path
    parent :about
  end
end