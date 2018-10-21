Rails.application.routes.draw do
	resources :users
	resources :workouts
	#write custom routes for custom requests for joined_workouts
end
