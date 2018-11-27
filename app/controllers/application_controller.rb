class ApplicationController < ActionController::API
	before_action :authenticate_request
	attr_reader :current_user

	private

	def authenticate_request
		@current_user = AuthorizeApiRequest.call(request.headers).result
		render json: { error: 'Not Authorized' }, status: 401 unless @current_user
	end

	#to check if user is logged in
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
