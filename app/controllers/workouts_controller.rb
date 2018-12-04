class WorkoutsController < ApplicationController
	# Documentation for User Controller
	swagger_controller :workout, "Workout"

	swagger_api :index do
		summary "Fetches all workouts"
		notes "There is no visibility settings at the moment; this action will allow filters and sorts."
	end

	swagger_api :show do 
		summary "Shows a particular workout's data"
		notes "This fetches all data related to the workout, including owner and joined workouts."
		param :form, :id, :integer, :required, "Workout ID"
		param :form, :user_id, :integer, "User ID"
		response :not_found
	end

	swagger_api :create do
		summary "Creates a workout with a given set of parameters"
		notes "For now, we are passing the owner as a parameter as we do not have authentication"
		# TODO : User ID should be removed later when there is an authentication
		param :form, :user_id, :integer, :required, "User ID"
		param :form, :title, :integer, :optional, "Title"
		param :form, :time, :string, :required, "Time"
		param :form, :duration, :string, :required, "Duration"
		param_list :form, :location, :string, :required, "Location", Workout::LOCATIONS
		param :form, :team_size, :string, :required, "Team Size"
		response :not_acceptable
	end

	swagger_api :update do
		summary "Updates a workout with a given set of parameters"
		notes "There is no authentication for update at the moment"
		param :form, :title, :integer, :optional, "Title"
		param :form, :time, :string, :required, "Time"
		param :form, :duration, :string, :required, "Duration"
		param_list :form, :location, :string, :required, "Location", Workout::LOCATIONS
		param :form, :team_size, :string, :required, "Team Size"
		response :not_acceptable
		response :not_found
	end

	swagger_api :destroy do
		summary "Destroys a workout"
		notes "There is no authentication for destroy at the moment"
		param :path, :id, :integer, :required, "Workout ID"
		response :not_found
	end
	
	# Callbacks
	before_action :set_workout, only: [:show, :update, :destroy, :finalize]

	# An endpoint to fetch all the workouts
	# Parameters: User ID
	# TODO : We want to limit the visibility for workouts depending on the user's profile information
	def index
		@workouts = Workout.all.chronological
		render json: @workouts
	end

	def archived
		@workouts = Workout.all.expired
		render json: @workouts
	end	

	def current
		@workouts = Workout.all.current
		render json: @workouts
	end

	# An endoint to show the workokut and related details
	# Parameters: User ID, Workout ID
	# Note: Returns all related information such as all joined_workouts and 
	def show
		unless params[:user_id]
			@joined_workouts = @workout.joined_workouts
			render :json => {:workout => @workout, :joined_workouts => @joined_workouts.map {|jw| [jw, jw.user] }, :owner => @workout.user}
		else
			#owner call
			if params[:user_id].to_i == @workout.user.id
				@joined_workouts = @workout.joined_workouts
				render :json => {:workout => @workout, :joined_workouts => @joined_workouts.map {|jw| [jw, jw.user] }, :owner => @workout.user}
			#accepted user call
			elsif @workout.joined_workouts.accepted_users.map{|jw| jw.user.id }.include?(params[:user_id].to_i)
				@joined_workouts = @workout.joined_workouts.accepted_users
				render :json => {:workout => @workout, :joined_workouts => @joined_workouts.map {|jw| [jw, jw.user] }, :owner => @workout.user}
			#unaccepted user call
			elsif @workout.joined_workouts.unaccepted_users.map{|jw| jw.user.id }.include?(params[:user_id].to_i)
				@joined_workouts = @workout.joined_workouts.where("user_id=? OR user_id=?", params[:user_id].to_i, @workout.user.id)
				render :json => {:workout => @workout, :joined_workouts => @joined_workouts.map {|jw| [jw, jw.user] }, :owner => @workout.user}
			#stranger call
			else
				@joined_workouts = @workout.joined_workouts.where(workout_id: @workout.id, user_id: @workout.user.id)
				render :json => {:workout => @workout, :joined_workouts => @joined_workouts.map {|jw| [jw, jw.user] }, :owner => @workout.user}
			end
		end
	end

	# An endpoint to creates a workout
	# Parameters: workout_params method
	# Side Effect: JoinedWorkout is created with a user_id
	def create
		@workout = Workout.new(workout_params)
		# Finalized is set by the server
		@workout.finalized = false
		if @workout.save
			# TODO : USER_ID IS A DUMMY; PUT AN ACTUAL USER ID
			info = {user_id: @workout.user_id, workout_id: @workout.id, approved: true, checked_in: false, accepted: true}
			JoinedWorkout.create(info)
			render json: @workout, status: :created
		else
			render json: @workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to update the workout 
	# Parameters: workout_params method and workout_id
	def update
		if @workout.update(workout_params)
			render json: @workout
		else
			render json: @workout.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to destroy the workout
	# Parameters: workout_id 
	def destroy
		@workout.delete
	end

	def finalize
		if @workout.update(finalized: true)
			render json: @workout
		else
			render json: @workout.errors, status: :unprocessable_entity
		end
	end

	private
	# Method to set the workout before certain actions: SHOW, UPDATE, DESTROY
	def set_workout
		@workout = Workout.find(params[:id])
	end

	# Parameter for creating a workout 
	# TODO : Make a separate endpoint for updating a workout / finalizing a workout
	# TODO : Take out user_id once authentication is in place
	def workout_params
		params.permit(:title, :time, :duration, :location, :team_size, :user_id)
	end

end