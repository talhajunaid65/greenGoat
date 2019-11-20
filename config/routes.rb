Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :projects
	post '/projects/zillow-flow', to: 'projects#zillow_flow'

	get '/myprofile', to: 'user_profile#show'

	get '/myactivity', to: 'projects#my_activity'

end
