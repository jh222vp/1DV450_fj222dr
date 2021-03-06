require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	def setup 
		@user = users(:filip)
		@wrong_user = users(:wrong_user)
		@non_admin_user = users(:non_admin_user)
	end


	# Index user tests

	test "should list all users" do
		
		log_in_as @user

		get :index
		assert_response :success

		assert_template :index
  		assert_template layout: "layouts/application"

  		User.paginate(page: 1).each do |user|
  			assert_select 'a[href=?]', user_path(user)
  		end
	end


	test "should fail to list users when not logged in" do
		get :index
		assert_redirected_to login_path	
	end


	test "should fail to list users when not admin" do

		log_in_as @wrong_user

		get :index
		assert_redirected_to root_path	
	end



	# Show user tests

	test "should show user" do

		log_in_as @non_admin_user

		get :show, {id: @non_admin_user.id} 
		assert_response :success

		assert_template :show
	  	assert_template layout: "layouts/application"

	  	assert_not_nil assigns(:user)
	  	assert_equal assigns(:user), @non_admin_user
	end


	test "should fail to show when not logged in" do
		get :show, {id: @user.id}
		assert_redirected_to login_path		
	end


	test "should fail to show when wrong user" do
		log_in_as @non_admin_user
		get :show, { id: @wrong_user.id }
		assert_redirected_to root_path	
	end


	test "should show other user when admin" do 
		log_in_as @user
		get :show, {id: @non_admin_user.id} 
		assert_response :success
	end



	# New user tests
 
	test "should get new" do
		get :new
		assert_response :success

		assert_template :new
  		assert_template layout: "layouts/application"
	end


	test "should route to user form" do
		assert_recognizes({controller: 'users', action: 'new'}, '/signup')
	end



	# Create user tests

	test "should create user" do
		get :new
		assert_difference 'User.count', 1 do
			post :create, user: {email: "a@b.c",name: "Foo Bar", password: "Password", password_confirmation: "Password"} 
		end

		assert_redirected_to root_path
		
		
		assert is_logged_in?
		assert_equal "Du är nu registrerad!", flash[:success]
	end


	test "should fail to create user" do
		get :new
		assert_no_difference 'User.count' do
			post :create, user: {email: "",name: "Foo Bar", password: "Password", password_confirmation: "Password"} 
		end

		assert_template :new
		assert assigns(:user).errors
	end



	# Edit user tests

	test "should get edit" do

		log_in_as @non_admin_user

		get :edit, {id: @non_admin_user.id}
		assert_response :success

		assert_template :edit
  		assert_template layout: "layouts/application"
	end


	test "should fail to edit when not logged in" do
		get :edit, {id: @user.id}
		assert_redirected_to login_path		
	end


	test "should fail to edit when wrong user" do
		log_in_as @non_admin_user
		get :edit, { id: @wrong_user.id }
		assert_redirected_to root_path	
	end


	
	# Update user tests
	
	test "should update user" do

		log_in_as @non_admin_user

		get :edit, {id: @non_admin_user.id}
		
		email = "new@mail.com"
		name = "new name"


		patch :update, {id: @non_admin_user.id, user: { email: email, name: name }} 

		assert_redirected_to @non_admin_user

		assert_equal "Redigeringen lyckades!", flash[:success]

		@non_admin_user.reload		

		assert_equal @non_admin_user.email, email
		assert_equal @non_admin_user.name,  name

		patch :update, {id: @non_admin_user.id, user: { email: email, name: name, password: "NewPassword", password_confirmation: "NewPassword" }}

		assert_redirected_to @non_admin_user

		assert_equal "Redigeringen lyckades!", flash[:success]
	end	


	test "should fail to update user" do

		log_in_as @non_admin_user

		get :edit, {id: @non_admin_user.id}

		patch :update, {id: @non_admin_user.id, user: {id: @non_admin_user.id, email: "", name: "Namn", }} 

		assert_template :edit
	  	assert_template layout: "layouts/application"

	  	assert assigns(:user).errors
	end
	 

	test "should fail to update when not logged in" do
		patch :update, {id: @user.id, user: { email: @user.email, name: @user.name }} 
		assert_redirected_to login_path		
	end


	test "should fail to update when wrong user" do
		log_in_as @non_admin_user
		patch :update, {id: @wrong_user.id, user: { email: @non_admin_user.email, name: @non_admin_user.name }} 
		assert_redirected_to root_path
	end



	# Destroy user tests
	
	test "should remove user" do

		log_in_as @user
		
		assert_difference 'Apikey.count', -2 do
			assert_difference 'User.count', -1 do
				delete :destroy, {id: @non_admin_user.id}
			end
		end

		assert_redirected_to users_path

		assert_equal "Användaren har tagits bort!", flash[:success]

	end


	test "should fail to remove user when not logged in" do
		assert_no_difference 'User.count' do
			delete :destroy, {id: @non_admin_user.id}
		end
		assert_redirected_to login_path	
	end


	test "should fail to remove user when not admin" do

		log_in_as @wrong_user

		assert_no_difference 'User.count' do
			delete :destroy, {id: @non_admin_user.id}
		end
		assert_redirected_to root_path	
	end
	
end
