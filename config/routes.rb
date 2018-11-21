Rails.application.routes.draw do
	# Rails basic resources
	resources :users
	resources :workouts
	resources :joined_workouts, only: [:create, :destroy]

	# Custom Routes
	patch 'joined_workouts/:id/approve', to: 'joined_workouts#approve'
	patch 'joined_workouts/:id/accept', to: 'joined_workouts#accept'
	patch 'workouts/:id/finalize', to: 'workouts#finalize'
	# Authentication routes
	post 'login' => 'sessions#create', :as => :login
	post 'logout' => 'sessions#destroy', :as => :logout

end