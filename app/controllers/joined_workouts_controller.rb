class JoinedWorkoutsController < ApplicationController
	# Documentation for User Controller
	swagger_controller :joined_workout, "Joined Workout"

	swagger_api :create do
		summary "Joins a user into a workout through the joined workout table"
		notes "Doesn't have authentication for user_id; will be added later."
		# TODO : ADD IN AUTHENTICATION THEN USE THE USER ID
		param :form, :user_id, :integer, :required, 'User ID'
		param :form, :workout_id, :integer, :required, 'Workout ID'
		response :not_acceptable
	end

	swagger_api :accept do 
		summary "Updates the joined workout to be accept"
		notes "When user joins a workout, the host has to accept that particular user."
		param :path, :id, :integer, :required, "Joined Workout ID"
		response :not_found
	end
	
	swagger_api :approve do 
		summary "Updates the joined workout to be approve"
		notes "When the host changes a workout detail, the user has to approve the workout again."
		param :path, :id, :integer, :required, "Joined Workout ID"
		response :not_found
	end

	swagger_api :destroy do
		summary "Destroys a joined workout with a given set of parameters"
		notes "Doesn't have authentication for user_id; will be added later. Anyone can leave a workout. Will have some penalties for leaving later."
		param :path, :id, :integer, :required, "Joined Workout ID"
		response :not_found
	end

	# Callbacks
	before_action :set_joined_workout, only: [:update, :accept, :approve, :destroy]

	# An endpoint to create a joined workout
	# Parameters: joined_workout params
	# TODO : Use authentication to set the user_id.. but you can use workout_id
	def create
		info = {user_id: params[:user_id], workout_id: params[:workout_id], approved: true, checked_in: false, accepted: false}
		@joined_workout = JoinedWorkout.new(info)
		if @joined_workout.save
			render json: @joined_workout, status: :created, location: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint for the host to accept a user into a workout
	# Parameters: joined_workout id
	# TODO : Use authentication to check that the owner is calling this
	def accept
		if @joined_workout.update(accepted: true)
			render json: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint for a user to approve a change in the workout
	# Parameters: joined_workout id  
	# TODO : Use authentication to check that 
	def approve 
		if @joined_workout.update(approved: true)
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
		@joined_workout = JoinedWorkout.find(params[:id])
	end

end