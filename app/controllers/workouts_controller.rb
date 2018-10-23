class WorkoutsController < ApplicationController
		# Documentation for User Controller
		swagger_controller :workout, "Workout"

		swagger_api :index do
			summary "Fetches all workouts"
			notes "There is no visibility settings at the moment"
		end
	
		swagger_api :show do 
			summary "Shows a particular user's data"
			param :path, :id, :integer, :required, "User ID"
			notes "This fetches a single user"
			response :not_found
		end
	
		swagger_api :create do
			summary "Creates a user with a given set of parameters"
			param :form, :facebook_id, :integer, :optional, "Facebook ID"
			param :form, :email, :string, :required, "Email"
			param :form, :password, :string, :required, "Password"
			param :form, :password_confirmation, :string, :required, "Password Confirmation"
			param_list :form, :role, :string, :required, "Role", ['Real']
			param :form, :first_name, :string, :required, "First Name"
			param :form, :last_name, :string, :required, "Last Name"
			param :form, :gender, :string, :required, "Gender"
			param :form, :age, :integer, :required, "Age"
			response :not_acceptable
		end
	
		swagger_api :update do
			summary "Updates a user with a given set of parameters"
			param :path, :id, :integer, :required, "User ID"
			param :form, :password, :string, :required, "Password"
			param :form, :password_confirmation, :string, :required, "Password Confirmation"
			param :form, :first_name, :string, :required, "First Name"
			param :form, :last_name, :string, :required, "Last Name"
			param :form, :gender, :string, :required, "Gender"
			param :form, :age, :integer, :required, "Age"
			response :not_acceptable
			response :not_found
		end
	
		swagger_api :destroy do
			summary "Destroys a user with a given set of parameters"
			param :path, :id, :integer, :required, "User ID"
			response :not_found
		end
	
	# Callbacks
	before_action :set_workout, only: [:show, :update, :destroy]

	# authorize_resource is used by cancancan to see where it should be applied
	authorize_resource

	def index
		@workouts = workout.all
		render json: @workouts
	end

	# Getting the information for the workout and the joined workouts
	def show
		@joined_workouts = @workout.joined_workouts
		respond_to do |format|
			format.json  { render :json => {:workout => @workout, 
											:joined_workouts => @joined_workouts }}
		end		  
	end

	def create
		@workout = workout.new(workout_params)
		if @workout.save
			#set and save joined_workout for owner when creating workout
			info = {user_id: session[:user_id], workout_id: @workout.id, approved: true, checked_in: false, accepted: true}
			JoinedWorkout.create(info)
			render json: @workout, status: :created, location: @workout
		else
			render json: @workout.errors, status: :unprocessable_entity
		end
	end

	def update
		if @workout.update(workout_params)
			render json: @workout
		else
			render json: @workout.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@workout.delete
	end

	private
	def set_workout
		@workout.workout.find(params[:id])
	end

	def workout_params
		params.permit(:title, :time, :duration, :location, :team_size, :finalized)
	end
end