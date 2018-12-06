class JoinedWorkout < ApplicationRecord
	#Relationships
	belongs_to :user
	belongs_to :workout

	#Validations
	validates_uniqueness_of :user_id, scope: :workout_id
	validate :ensure_under_limit, :on => :create
	validate :prevent_when_finalized, :on => :create

	#Scopes
	scope :accepted_users, -> { where(accepted: true) }
	scope :unaccepted_users, -> { where(accepted: false) }

	private
	def ensure_under_limit
		if self.workout.joined_workouts.accepted_users.count + 1 > self.workout.team_size
			errors.add(:base, "workout already full")
		end
	end

	def prevent_when_finalized
		if self.workout.finalized
			errors.add(:base, "workout already finalized")
			return false
		else 
			return true
		end
	end
end
