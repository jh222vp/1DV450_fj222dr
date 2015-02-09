class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def show 
		@user = User.find(params[:id])
	end	

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			redirect_to @user
		else 
			render 'new'
		end
	end	

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to @user
		else 
			render 'edit'
		end
	end	


	def destroy
		User.find(params[:id]).destroy
		redirect_to users_path
	end	

	private

		def user_params
			params.require(:user).permit(:email, :name, :password, :password_confirmation)
		end	

end
