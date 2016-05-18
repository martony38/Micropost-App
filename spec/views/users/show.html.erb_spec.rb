require 'rails_helper'

def render_user_page(user)
	log_in_as(user)
	render template: "users/show.html.erb", layout: "layouts/application.html.erb"
end

RSpec.describe "users/show.html.erb", type: :view do

	let(:user) { create :donald }
    it "displays the correct page title" do
    	render_user_page(user)
      	assert_select "title", "#{user.name} | Lolo Cool Website"
    end
    it "displays the links to the home page" do
    	render_user_page(user)
		assert_select "a[href=?]", root_path, count: 2
	end
    it "displays the link to the help page" do
    	render_user_page(user)
		assert_select "a[href=?]", help_path
	end
    it "displays the link to the about page" do
    	render_user_page(user)
		assert_select "a[href=?]", about_path
	end
    it "displays the link to the contact page" do
    	render_user_page(user)
		assert_select "a[href=?]", contact_path
	end
	it "displays the link to the logout page" do
		render_user_page(user)
		assert_select "a[href=?]", logout_path
	end
	it "displays the link to the profile page" do
		render_user_page(user)
		assert_select "a[href=?]", user_path(user)
	end
	it "does not display the link to the login page" do
		render_user_page(user)
		assert_select "a[href=?]", login_path, count: 0
	end

end