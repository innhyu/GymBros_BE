Rails.application.routes.draw do
	resources :users
	resources :workouts
	resources :joined_workouts
	#write custom routes for custom requests for joined_workouts
end
