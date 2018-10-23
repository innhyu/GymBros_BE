class User < ApplicationRecord
	#Use Bcrypt gem for secure passwords
	has_secure_password

	#Used for role? method and sometimes views
	ROLES = [['Real', :real]]
	ROLES_LIST = ['Real']
	GENDERS = ['Male', 'Female', 'Other']

	#Validations
	validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
    validates :role, presence: true, inclusion: { in: ROLES_LIST }
    validates :gender, presence: true, inclusion: { in: GENDERS }
    validates_presence_of :password, :first_name, :last_name, :age
    validates_numericality_of :age, less_than: 150, greater_than_or_equal_to: 18
    validates_confirmation_of :password

	#Relationships
	has_many :workouts
	has_many :joined_workouts

	#Use this to see if user exists in database, used in ability.rb
	def role?(authorized_role)
		return false if role.nil?
		role.downcase.to_sym == authorized_role
	end
end
