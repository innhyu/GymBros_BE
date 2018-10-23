Rails.application.routes.draw do
	# Rails basic resources
	resources :users
	resources :workouts
	resources :joined_workouts

	# Custom Routes
	post 'joined_workouts/approve' => 'joined_workout#approve'
 	post 'joined_workouts/accept' => 'joined_workout#accept'

end
