Dummy::Application.routes.draw do
  root :to => "home#root"

  match "about"              => "home#about",         :as => :about
  match "about/contact"      => "home#contact",       :as => :contact
  match "about/contact/form" => "home#contact_form",  :as => :contact_form

  resources :projects do
    resources :issues
  end

  [ :root,
    :simple,
    :with_root,
    :without_root,
    :with_autopath,
    :with_parent,
    :with_parent_object,
    :multiple_links,
    :multiple_links_with_parent ].each do |action|
      match action.to_s => "home##{action}", :as => action
  end
end