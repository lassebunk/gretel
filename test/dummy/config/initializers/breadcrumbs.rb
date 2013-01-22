Gretel::Crumbs.layout do
  crumb :root do
    link "Home", root_path
  end

  crumb :basic do
    link "About", about_path
  end

  crumb :with_root do
    link "About", about_path
    parent :root
  end

  crumb :with_parent do
    link "Contact", contact_path
    parent :basic
  end

  crumb :object do |project|
    link project.name, project
  end

  crumb :with_autopath do |project|
    link project.name, project
  end

  crumb :with_parent_object do |issue|
    link issue.title, project_issue_path(issue.project, issue)
    parent :object, issue.project
  end

  crumb :multiple_links do
    link "Contact", contact_path
    link "Contact form", contact_form_path
  end

  crumb :multiple_links_with_parent do
    link "Contact", contact_path
    link "Contact form", contact_form_path
    parent :basic
  end
end