class SessionsController < ApplicationController
	#Controls sessions, user abilities are defined in the ability.rb model file
	def create
		user = User.find_by_email(params[:email])
		print(params)
		if user# && user.authenticate(params[:password])
			session[:user_id] = user.id
			render json: user
		else
			render json: nil, status: :unprocessable_entity
		end
	end

	def destroy
		session[:user_id] = nil
	end
end