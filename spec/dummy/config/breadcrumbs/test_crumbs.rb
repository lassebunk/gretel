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

crumb :with_multiple_arguments do |a, b, c|
  link "#{a} and #{b} and #{c}", contact_path
  parent :parent_with_multiple_arguments, a * 2, b * 2, c * 2
end

crumb :parent_with_multiple_arguments do |d, e, f|
  link "First #{d} then #{e} then #{f}", about_path
end

crumb :with_unsafe_html do
  link "Test <strong>bold text</strong>", about_path
end

crumb :with_safe_html do
  link "Test <strong>bold text</strong>".html_safe, about_path
end

crumb :without_link do
  link "Without link"
  parent :parent_without_link
end

crumb :parent_without_link do
  link "Also without link"
end

crumb :using_view_helper do
  link times_two("Test"), about_path
end

crumb :project do |project|
  link project.name, project
end

crumb :with_link_options do
  link "Test", about_path, title: "My Title", other: "Other Option"
  link "Other Link", some_option: "Test"
end

crumb :with_inferred_parent do
  link "Test", about_path
  parent Project.first
end