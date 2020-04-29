Rails.application.routes.draw do

  root to: 'admin/dashboard#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/users/registrations',
        confirmations: 'api/v1/users/confirmations'
      }
      resources :orders, only: %i[create]
      resources :group_items, only: %i[index show]
      resources :home_images, only: %i[index]
      resources :projects
      resources :products, only: %i[index show] do
        get :categories, on: :collection
      end
      resources :favourites, only: %i[index]
      resources :wishlists, only: %i[index create destroy]

      get '/myprofile', to: 'user_profile#show'
      get '/myactivity', to: 'activities#index'

      post '/favourites/add-to-favourite', to: 'favourites#add_to_favourite'
      post '/favourites/remove-from-favourite', to: 'favourites#remove_from_favourite'
      post '/projects/zillow-flow', to: 'projects#zillow_flow'
      post '/contact-us', to: 'projects#contact_us'
    end
  end

  namespace :users do
    resources :passwords, only: %i[create edit update]
  end

  resources :pages, only: [:index]
end
