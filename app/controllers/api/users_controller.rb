class Api::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :find_user, only: [:show, :update, :destroy]

	def index
		@users = User.paginate(page: params[:page], per_page: 3)
		render json: @users
	end

	def show
		render json: @user
	end

	def create
		@user = User.new(user_params)
		if @user.save
			render :json => "User Successfully Created!"
		else
			render :json => "User not create."
		end
	end

	def update
		if @user.update(user_params)
			render :json => @user
		else
			render :json => "User not updated."
		end
	end

	def destroy
		begin
      @user.destroy
    rescue => e
      logger.info e
      return render json: { message: 'user id not found' }, status: :not_found
    end
    render json: @user
	end

	def typeahead
		users = User.where('first_name LIKE :input OR last_name LIKE :input OR email LIKE :input', input: "%#{params[:input]}%")
		render json: users
	end

	private
	def user_params
		params.require(:user).permit!
	end

	def find_user
		@user = User.find_by_id(params[:id])
	end
end
