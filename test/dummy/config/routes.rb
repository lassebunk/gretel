Dummy::Application.routes.draw do
  root :to => "test#root"

  match "about"              => "dummy#dummy", :as => :about
  match "about/contact"      => "dummy#dummy", :as => :contact
  match "about/contact/form" => "dummy#dummy", :as => :contact_form

  [ :basic,
    :with_root,
    :with_autopath,
    :with_parent,
    :with_parent_object,
    :multiple_links,
    :multiple_links_with_parent,
    :semantic,
    :no_breadcrumb,
    :link_current,
    :pretext,
    :posttext,
    :separator,
    :autoroot,
    :element_id ].each do |action|
      match action.to_s => "test##{action}", :as => action
  end

  resources :projects do
    resources :issues
  end
end