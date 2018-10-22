class ApplicationController < ActionController::API
	private
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	#helper_method :current_user

	def logged_in?
		current_user
	end
	#helper_method :logged_in?

	rescue_from CanCan::AccessDenied do |exception|
		render json: nil, status: :unprocessable_entity
	end
end
