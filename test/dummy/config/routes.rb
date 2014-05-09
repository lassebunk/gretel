Dummy::Application.routes.draw do
  root to: "dummy#dummy"

  get "about"              => "dummy#dummy", as: :about
  get "about/contact"      => "dummy#dummy", as: :contact
  get "about/contact/form" => "dummy#dummy", as: :contact_form

  resources :projects do
    resources :issues
  end
end
