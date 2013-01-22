Dummy::Application.routes.draw do
  root :to => "home#index"

  match "about" => "home#about", :as => :about
  match "about/contact", "home#contact", :as => :contact
  match "about/contact/form", "home#contact_form", :as => :contact_form

  resources :projects do
    resources :issues
  end
end