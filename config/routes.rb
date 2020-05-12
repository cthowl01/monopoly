Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'home#index'
  get "/about", :controller => "home", :action => "about"
  get "/load_active", :controller => "home", :action => "load_active"
  get "/load_available", :controller => "home", :action => "load_available"
  resources :games do
    patch :forfeit
  end
  resources :properties , only: :update
  resources :users, only: :show

  get 'games/:id/roll', :controller => "games", :action => "roll"
  get 'games/:id/move', :controller => "games", :action => "move"
  get 'games/:id/purchase', :controller => "games", :action => "purchase"
  get 'games/:id/pass', :controller => "games", :action => "pass"
  get 'games/:id/penalty', :controller => "games", :action => "penalty"
  get 'games/:id/pay_rent', :controller => "games", :action => "pay_rent"
  get 'games/:id/chance', :controller => "games", :action => "chance"
  get 'games/:id/jail', :controller => "games", :action => "jail"
  get 'games/:id/load_board', :controller => "games", :action => "load_board"
  get 'games/:id/update_piece/:piece', :controller => "games", :action => "update_piece"
  get 'games/:id/mortgage/:mortgage_id', :controller => "games", :action => "mortgage"
  get 'games/:id/unmortgage/:mortgage_id', :controller => "games", :action => "unmortgage"
end
