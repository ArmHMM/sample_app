require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	
	def setup
		ActionMailer::Base.deliveries.clear
	end

  test "invalid signup information" do
	  get signup_path
	  assert_no_difference 'User.count' do
		  post users_path, params: { user:{ name: "",
		                                    email: "user@invalid",
		  				                    password:              "foo",
		                                    password_confirmation: "bar" } }
	  end
	  assert_template 'users/new'
	  assert_select 'div#error_explanation'
	  assert_select 'div.field_with_errors'
  end

  # tests que puse yo -----
  test "invalid user name" do
	  get signup_path
	  assert_no_difference 'User.count' do
		  post users_path, params: {user: { name: "foo",
		  				    email: "user@invalid", 
		  				    password: "",
		  				    password_confirmation: "" } }
	  end
	  assert_template 'users/new'
  end
  
  test "invalid email" do
      get signup_path
      assert_no_difference 'User.count' do
          post users_path, params: {user: { name: "", 
                                            email: "foo@foo",
                                            password: "",
                                            password_confirmation: "" } }
      end
  end  
      
  # fin de tests que puse yo......
  
  # flash test
  test "valid signup information" do
      get signup_path
      assert_difference 'User.count', 1 do
	      post users_path, params: {user: { name: "Example User",
	      					email: "user@example.com",
	      					password:              "password",
	      					password_confirmation: "password" } }
      end
      follow_redirect!
      #assert_template 'users/show'
      #assert_not flash.empty?
      #assert is_logged_in?
  end
  
  
  # added feb 19, 2020
  test "valid signup information with account activation" do
  	  get signup_path
  	  assert_difference 'User.count', 1 do
  	  	  post users_path, params: { user: { name: "rr",  
  	  	  									 email: "r1@example.com",
  	  	  									 password: "password", 
  	  	  									 password_confirmation: "password"}}
  	  end
  	  
  	  assert_equal 1, ActionMailer::Base.deliveries.size
  	  user = assigns(:user)
  	  assert_not user.activated?
  	  
  	  #try to log before activation
  	  log_in_as(user)
  	  assert_not is_logged_in?
  	  #Invalid activation token
  	  get edit_account_activation_path("invalid token", email: user.email)
  	  assert_not is_logged_in?
  	  #Valid token, wrong email
  	  get edit_account_activation_path(user.activation_token, email: 'wrong')
  	  assert_not  is_logged_in?
  	  #Valid activation token
  	  get edit_account_activation_path(user.activation_token, email: user.email)
  	  assert user.reload.activated?
  	  follow_redirect!
  	  assert_template 'users/show'
  	  assert is_logged_in?
  end
  
end
