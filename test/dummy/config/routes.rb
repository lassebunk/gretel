Dummy::Application.routes.draw do
  root to: "dummy#dummy"

  match "about"              => "dummy#dummy", as: :about
  match "about/contact"      => "dummy#dummy", as: :contact
  match "about/contact/form" => "dummy#dummy", as: :contact_form

  resources :projects do
    resources :issues
  end
end