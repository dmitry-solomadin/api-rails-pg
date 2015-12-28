Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :posts, except: [:new, :edit]
  resources :comments, except: [:new, :edit]
  resources :users, only: [:show]
end
