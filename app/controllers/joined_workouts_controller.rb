class JoinedWorkoutsController < ApplicationController
	before_action :set_joined_workout, only: [:update, :destroy]
	authorize_resource

	def create
		info = {user_id: session[:user_id], workout_id: params[:workout_id], approved: true, checked_in: false, accepted: true}
		@joined_workout = JoinedWorkout.new(info)
		if @joined_workout.save
			render json: @joined_workout, status: :created, location: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	def update
		if @joined_workout.update(joined_workout_params)
			render json: @joined_workout
		else
			render json: @joined_workout.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@joined_workout.delete
	end

	private
	def set_joined_workout
		@joined_workout.JoinedWorkout.find(params[:id])
	end

	def joined_workout_params
		params.permit(:approved, :checked_in)
	end
end