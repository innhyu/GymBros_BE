Rails.application.routes.draw do
	# Rails basic resources
	resources :users
	resources :workouts, only: [:update, :destroy, :create]
	resources :joined_workouts, only: [:create, :destroy]

	# Custom Routes
	patch 'joined_workouts/:id/approve', to: 'joined_workouts#approve'
	patch 'joined_workouts/:id/accept', to: 'joined_workouts#accept'
	patch 'workouts/:id/finalize', to: 'workouts#finalize'
	get 'workouts_archived' => 'workouts#archived'
	get 'workouts_current' => 'workouts#current'
	patch 'joined_workouts/:id/check_in', to: 'joined_workouts#check_in'
	get 'workouts/:user_id' => 'workouts#index'

	# Authentication routes
	post 'login' => 'sessions#create', :as => :login
	post 'logout' => 'sessions#destroy', :as => :logout

	# Custom Show route
	get 'workouts/:id/:user_id' => 'workouts#show'

end