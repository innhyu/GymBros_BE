class User < ApplicationRecord
	#Use Bcrypt gem for secure passwords
	has_secure_password

	#Used for role? method and sometimes views
	ROLES = [['Real', :real]]

	#Use this to see if user exists in database, used in ability.rb
	def role?(authorized_role)
		return false if role.nil?
		role.downcase.to_sym == authorized_role
	end
end
