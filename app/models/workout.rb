class Workout < ApplicationRecord

	# List of acceptable locations
	LOCATIONS = ['WIEGAND GYMNASIUM', 'JARED L. COHON CENTER GYMNASIUM', 'SKIBO GYMNASIUM']

	# Relationship
	has_many :joined_workouts
	belongs_to :user

	# Validations for fields
	validates :title, presence: true, length: { minimum: 4 }, message: "Title must be longer than 4 characters"
	validates_date :time, :on_or_after => lambda { Date.now + 1.hours }, message: "Time is not in a valid format"
	validates_numericality_of :duration, only_integer: true, greater_than_or_equal_to: 30, less_than: 300
	validates :location, presence: true, inclusion: { in: LOCATIONS }, message: "Location not supported"
	validates_numericality_of :team_size, only_integer: true, less_than: 10, greater_than_or_equal_to: 2
	validates :finalized, presence: true

	
end
