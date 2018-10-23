class JoinedWorkoutsController < ApplicationController
	# Documentation for User Controller
	swagger_controller :joined_workout, "Joined Workout"

	swagger_api :create do
		summary "Joins a user into a workout through an extra table"
		# TODO : ADD IN AUTHENTICATION THEN USE THE USER ID
		param :form, :user_id, :integer, :required, 'User ID'
		param :form, :workout_id, :integer, :required, 'Workout ID'
		response :not_acceptable
	end

	swagger_api :accept do 
		summary "Updates the joined workout to be accept"
		param :path, :id, :integer, :required, "Joined Workout ID"
		param :form, :workout_id, :integer, :required, "Workout ID"
		param :form, :user_id, :integer, :required, 'User ID'
		response :not_found
	end
	
	swagger_api :approve do 
		summary "Updates the joined workout to be approve"
		param :path, :id, :integer, :required, "Joined Workout ID"
		param :form, :workout_id, :integer, :required, "Workout ID"
		param :form, :user_id, :integer, :required, 'User ID'
		response :not_found
	end

	swagger_api :destroy do
		summary "Destroys a joined workout with a given set of parameters"
		param :path, :id, :integer, :required, "Joined Workout ID"
		response :not_found
	end

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

	# An endpoint for the host to accept a user into a workout
	# Parameters: joined_workout id
	# TODO : Use authentication to check that the owner is calling this
	def accept
		if @joined_workout.update(accept: true)
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
		@joined_workout.JoinedWorkout.find(params[:id])
	end

end