require 'test_helper'

class UserEdittest < ActionDispatch::IntegrationTest
      def setup
      	  @user = users(:pepito)
      	  @other_user = users(:juan)
      end

      test "unsuccessful edit" do
      	  log_in_as(@user)
      	  get edit_user_path(@user)
      	  assert_template 'users/edit'
      	  patch user_path(@user), params: { user: { name: "",
	  									    email: "foo@invalid",
	  									    password: "foo",
	  					    				password_confirmation: "bar" } }

	  	  assert_template 'users/edit'
      end

      test "successful edit" do
      	  log_in_as(@user)
      	  get edit_user_path(@user)
      	  assert_template 'users/edit'
      	  name = "Foo Bar"
      	  email = "foo@bar.com"
      	  patch user_path(@user), params: { user: { name: name,
	 											    email: email,
	 											    password:              "", 
	 					    						password_confirmation: "" } }
	 	  assert_not flash.empty?
	 	  assert_redirected_to @user
	 	  @user.reload
	 	  assert_equal name, @user.name
	 	  assert_equal email, @user.email
      end

      test "successful edit with friendly forwarding" do
          get edit_user_path(@user)
          log_in_as(@user)
          assert_redirected_to edit_user_url(@user)
          name = "Foo Bar"
          email = "foo@bar.com"
          patch user_path(@user), params: { user: { name: name,
	  											    email: email,
	  											    password:              "",
	  					    						password_confirmation: "" } }

	  	  assert_not flash.empty?
	      assert_redirected_to @user
	      @user.reload
	      assert_equal name, @user.name
	      assert_equal email, @user.email
      end


      ## test added by me, feb 17,2020
      test "Forwarding url" do
      	  get edit_user_path(@other_user)
      	  log_in_as(@other_user)
      	  assert_redirected_to edit_user_url(@other_user)
      	  name = "Foo Bar"
          email = "foo@bar.com"
          patch user_path(@other_user), params: { user: { name: name,
	  											    email: email,
	  											    password:              "",
	  					    						password_confirmation: "" } }

	  	  assert_not flash.empty?
	      assert_redirected_to @other_user
	      @other_user.reload
	      assert_equal name, @other_user.name
	      assert_equal email, @other_user.email
      end
end
