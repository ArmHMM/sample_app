require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
	@other_user = users(:juan)
  end
  
  test "layout links for non logged users" do 
        get root_path
        assert_template 'static_pages/home'
        assert_select "a[href=?]", root_path, count: 2
        assert_select "a[href=?]", help_path
        assert_select "a[href=?]", about_path
        assert_select "a[href=?]", contact_path
        assert_select "a[href=?]", login_path
        assert_select "a[href=?]", signup_path
	
	get contact_path
        assert_select "title", full_title("Contact")
  end
  
  test "layout links for logged users" do
	log_in_as(@other_user)
	get root_path
	assert_template 'static_pages/home'
	assert_select "a[href=?]", help_path
        assert_select "a[href=?]", about_path
        assert_select "a[href=?]", contact_path
	assert_select "a[href=?]", users_path
	assert_select "a[href=?]", user_path(@other_user)
  end
end
