#from https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api
class AuthenticationController < ApplicationController
 skip_before_action :authenticate_request

 def authenticate
   command = AuthenticateUser.call(params[:email], params[:password])
   user = User.find_by_email(params[:email])
   if command.success?
     render json: { auth_token: command.result, user: user }
   else
     render json: { error: command.errors }, status: :unauthorized
   end
 end
end