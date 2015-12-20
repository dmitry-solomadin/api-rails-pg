Rails.application.routes.draw do
  resources :posts, except: [:new, :edit]
  resources :comments, except: [:new, :edit]
  resources :users, except: [:new, :edit]
end
