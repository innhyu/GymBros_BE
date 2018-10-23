class UsersController < ApplicationController
	# Documentation for User Controller
	swagger_controller :user, "User"

	swagger_api :index do
		summary "Fetches all users"
		notes "There is no authentication at the moment"
	end

	swagger_api :show do 
		summary "Shows a particular user's data"
		param :path, :id, :integer, :required, "User ID"
		notes "This fetches a single user"
		response :not_found
	end

	swagger_api :create do
		summary "Creates a user with a given set of parameters"
		param :form, :facebook_id, :integer, :optional, "Facebook ID"
		param :form, :email, :string, :required, "Email"
		param :form, :password, :string, :required, "Password"
		param :form, :password_confirmation, :string, :required, "Password Confirmation"
		param_list :form, :role, :string, :required, "Role", User::ROLES_LIST
		param :form, :first_name, :string, :required, "First Name"
		param :form, :last_name, :string, :required, "Last Name"
		param_list :form, :gender, :string, :required, "Gender", User::GENDERS
		param :form, :age, :integer, :required, "Age"
		response :not_acceptable
	end

	swagger_api :update do
		summary "Updates a user with a given set of parameters"
		param :path, :id, :integer, :required, "User ID"
		param :form, :password, :string, :required, "Password"
		param :form, :password_confirmation, :string, :required, "Password Confirmation"
		param :form, :first_name, :string, :required, "First Name"
		param :form, :last_name, :string, :required, "Last Name"
		param :form, :gender, :string, :required, "Gender"
		param :form, :age, :integer, :required, "Age"
		response :not_acceptable
		response :not_found
	end

	swagger_api :destroy do
		summary "Destroys a user with a given set of parameters"
		param :path, :id, :integer, :required, "User ID"
		response :not_found
	end



	#standard api CRUD controller
	before_action :set_user, only: [:show, :update, :destroy]

	#for testing
	def index
		@users = User.all
		render json: @users
	end

	# An endpoint to fetch a user's profile info
	# Parameters: user_id
	def show
		render json: @user
	end

	# An endpoint to create a user
	# Parameters: user_params
	def create
		@user = User.new(user_params)
		if @user.save
			render json: @user, status: :created, location: @user
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to update a user
	# Parameters: user_params
	def update
		if @user.update(user_params)
			render json: @user
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# An endpoint to destroy a user
	# Parameters: user_id
	def destroy
		@user.delete
	end

	private
	def set_user
		@user.User.find(params[:id])
	end

	def user_params
		params.permit(:facebook_id, :email, :password, :password_confirmation, :role, :first_name, :last_name, :gender, :age)
	end
end