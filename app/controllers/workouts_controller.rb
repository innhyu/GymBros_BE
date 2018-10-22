class WorkoutsController < ApplicationController
	before_action :set_workout, only: [:show, :update, :destroy]
	#authorize_resource is used by cancancan to see where it should be applied
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

	{ workout: {name: asdf, id: asdf, joined_workout: {123, 456, 789}}}

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