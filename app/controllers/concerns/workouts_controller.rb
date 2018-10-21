class WorkoutsController < ApplicationController
	before_action :set_workout, only: [:show, :update, :destroy]

	def index
		@workouts = workout.all
		render json: @workouts
	end

	def show
		render json: @workout
	end

	def create
		@workout = workout.new(workout_params)

		if @workout.save
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
		params.permit(:title, :time, :duration, :location, :team_size)
	end
end