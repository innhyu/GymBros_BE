class User < ApplicationRecord
	#Use Bcrypt gem for secure passwords
	has_secure_password

	ROLES = [['Real', :real]]

	def role?(authorized_role)
		return false if role.nil?
		role.downcase.to_sym == authorized_role
	end
end
