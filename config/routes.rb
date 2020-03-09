Rails.application.routes.draw do

  root to: 'admin/dashboard#index'

  resources :orders
  resources :group_items
  resources :home_images
  resources :zillow_locations
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :projects
  resources :products, only: [:index, :show] do
    get :categories, on: :collection
  end

  post '/projects/zillow-flow', to: 'projects#zillow_flow'

  get '/myprofile', to: 'user_profile#show'

  get '/myactivity', to: 'activities#index'

  namespace :api, constraints: { format: 'json' } do
        mount_devise_token_auth_for 'User', at: 'auth', controllers: {
          registrations:  'users/registrations'
        }
  end

  resources :wishlists, only: %i[index]
  post '/wishlists/add-to-wishlist', to: 'wishlists#add_to_wishlist'
  post '/wishlists/remove-from-wishlist', to: 'wishlists#remove_from_wishlist'

  post '/contact-us', to: 'projects#contact_us'

  post '/checkout', to: 'orders#checkout'

  resources :tasks

end
