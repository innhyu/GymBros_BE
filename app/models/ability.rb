class Ability
	#This file defines the abliities of different users
	include CanCan::Ability

	def initialize(user)
		#here it asks if user exists, give them all power, else allow them to create more users
		#should probably be edited in the future to only allow users to change their own stuff
		#maybe add admins too for development
		user ||= User.new
		if user.role? :real
	    can :manage, :all
		else
		    can :create, :user
		end
	end
end
