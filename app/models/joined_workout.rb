class JoinedWorkout < ApplicationRecord
	#Relationships
	belongs_to :user
	belongs_to :workout

	#Validations
	validates_uniqueness_of :user_id, scope: :workout_id
	validate :ensure_under_limit, :on => :create

	#Scopes
	scope :accepted_users, -> { where(accepted: true) }
	scope :unaccepted_users, -> { where(accepted: false) }

	private
	def ensure_under_limit
		if self.workout.joined_workouts.count + 1 > self.workout.team_size
			errors.add(:base, "workout already full")
		end
	end
end
