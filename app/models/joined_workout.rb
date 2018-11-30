class JoinedWorkout < ApplicationRecord
	#Relationships
	belongs_to :user
	belongs_to :workout

	#Validations
	validates_uniqueness_of :user_id, scope: :workout_id

end
