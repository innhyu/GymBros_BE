class Workout < ApplicationRecord
	belongs_to :user

	# List of acceptable locations
	LOCATIONS = ['WIEGAND GYMNASIUM', 'JARED L. COHON CENTER GYMNASIUM', 'SKIBO GYMNASIUM']

	# Relationship
	has_many :JoinedWorkouts

	# Validations for fields
	validates :title, presence: true, length: { minimum: 4 }
	validates :time, presence: true
	validates :duration, presence: true
	validates :location, presence: true, inclusion: { in: LOCATIONS }
	validates :team_size, presence: true
	validates :finalized, presence: true

	
end
