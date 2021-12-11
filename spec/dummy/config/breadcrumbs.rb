crumb :root do
  link "Home", root_path
end

if crumb_defined?(:root)
  crumb :home1 do
    link "Home1", root_path
  end
else
  raise 'Unexpected'
end
