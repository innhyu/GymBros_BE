class Workout < ApplicationRecord

	#two more validations, delete unaccepted workouts when reaching limit
	#prevent editing workout team size to be less than already accepted joined workouts

	# List of acceptable locations
	LOCATIONS = ['WIEGAND GYMNASIUM', 'JARED L. COHON CENTER GYMNASIUM', 'SKIBO GYMNASIUM']

	#Scopes
	scope :expired, -> { where("time < ?", DateTime.now) }
	#scope :current, -> { where("time >= ?", DateTime.now ) }
	scope :chronological, -> { order('time') }

	# Relationship
	has_many :joined_workouts
	belongs_to :user

	# Validations for fields
	validates :title, presence: true, length: { minimum: 4 }
	validates_datetime :time, :on_or_after => lambda { DateTime.now.utc }
	validates_numericality_of :duration, only_integer: true, greater_than_or_equal_to: 30, less_than: 300
	validates :location, presence: true, inclusion: { in: LOCATIONS }
	validates_numericality_of :team_size, only_integer: true, less_than: 10, greater_than_or_equal_to: 2
	validate :not_finalized, on: :update
	validate :check_in_correct
	validate :team_size_above_actual
	
	def self.current
		result = []
		for workout in Workout.all.each do
			if workout.time + workout.duration * 60 >= DateTime.now
				result.append(workout)
			end
		end
		return Workout.where(id: result.map(&:id))
	end

	def not_finalized
		if self.finalized
			errors.add(:finalized, "is already finalized")
			return false
		else
			return true
		end
	end

	def check_in_correct
		if self.check_in_code == nil || check_in_code > 99999 || check_in_code < 1000000
			return true
		else
			errors.add(:check_in_code, "check_in code is not nil or does not have 6 digits")
			return false
		end
	end

	def everyone_approved
		for jw in self.joined_workouts.accepted_users.each do
			if !jw.approved
				return false
			end
		end
		return true
	end

	def check_and_destroy_unaccepted_users
		if self.finalized
			for jw in self.joined_workouts.unaccepted_users.each do
				jw.delete
			end
		end
		return true
	end

	def team_size_above_actual
		if self.team_size >= self.joined_workouts.accepted_users.count
			return true
		else
			errors.add(:team_size, "cannot be below already accepted users")
			return false
		end
	end

end
