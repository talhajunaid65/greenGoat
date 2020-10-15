Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  devise_for :users, controllers: { registrations: 'users/registrations' }

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
  resources :items, only: %i[index show]
  resources :wishlists, only: %i[index new create destroy]
  resources :favourites, only: %i[index] do
    collection do
      post :add_to_favourite
      post :remove_from_favourite
    end
  end
  resources :orders, only: %i[new create] do
    get :my, on: :collection
  end
  resources :projects, only: %i[new create]
  resources :group_items, only: %i[show]

  get 'home', to: 'pages#home'
  get 'grant_projects', to: 'pages#grant_projects'
  get 'recycling_plans', to: 'pages#recycling_plans'
  get 'need_more_info', to: 'pages#need_more_info'
  get 'what_we_take', to: 'pages#what_we_take'
  get 'our_mobile_app', to: 'pages#our_mobile_app'
  get 'join_email_list', to: 'pages#join_email_list'
  get 'press', to: 'pages#press'
  get 'who_are_we', to: 'pages#who_are_we'
  get 'contact', to: 'pages#contact'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'terms_and_conditions', to: 'pages#terms_and_conditions'
  get 'services', to: 'pages#services'
end
