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

  crumb :with_proc do
    link Proc.new { "Name from proc" }, Proc.new { "URL from proc" }
  end

  crumb :with_multiple_params do |a, b, c|
    link "#{a} and #{b} and #{c}", contact_path
    parent :parent_with_multiple_params, a * 2, b * 2, c * 2
  end

  crumb :parent_with_multiple_params do |d, e, f|
    link "First #{d} then #{e} then #{f}", about_path
  end

  crumb :with_unsafe_html do
    link "Test <strong>bold text</strong>", about_path
  end

  crumb :with_safe_html do
    link "Test <strong>bold text</strong>".html_safe, about_path
  end
end