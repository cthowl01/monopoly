Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"
  get "/load_active", :controller => "home", :action => "load_active"
  get "/load_available", :controller => "home", :action => "load_available"
  resources :games do
    patch :forfeit
  end
  get "roll", :controller => "games", :action => "roll"
end
