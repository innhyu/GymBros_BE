class JoinedWorkoutsController < ApplicationController
	# Callbacks
	before_action :set_joined_workout, only: [:update, :destroy]

	# An endpoint to create a joined workout
	# Parameters: joined_workout params
	# TODO : Use authentication to set the user_id
	def create
		info = {user_id: session[:user_id], workout_id: params[:workout_id], approved: true, checked_in: false, accepted: true}
		@joined_workout = JoinedWorkout.new(info)
		if @joined_workout.save
			render json: @joined_workout, status: :created, location: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to update joined workout
	# Parameters: joined_workout params
	# TODO : Use authentication to set the user_id
	def update
		if @joined_workout.update(joined_workout_params)
			render json: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to destroy a joined workout
	# Parameters: joined_workout params
	# TODO : Use user_id to check for permission; either the owner / user himself 
	def destroy
		@joined_workout.delete
	end

	private
	# Method to find set the joined workout before update and destroy endpoints
	def set_joined_workout
		@joined_workout.JoinedWorkout.find(params[:id])
	end

	# Permitted parameters for the joined_workout
	def joined_workout_params
		params.permit(:approved, :checked_in)
	end
end