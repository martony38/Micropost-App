require 'rails_helper'

RSpec.describe "users/show.html.erb", type: :view do

	let(:user) { create :donald }

    it "displays the correct page title" do
    	@user = user
    	render template: "users/show.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "#{user.name} | Ruby on Rails Tutorial Sample App"
    end
    it "displays the links to the home page" do
    	@user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", root_path, count: 2
	end
    it "displays the link to the help page" do
    	@user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", help_path
	end
    it "displays the link to the about page" do
    	@user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", about_path
	end
    it "displays the link to the contact page" do
    	@user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", contact_path
	end
	it "displays the link to the logout page" do
		#session[:user_id] = user.id
		log_in_as(user)
    	#@user = user
    	#@current_user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", logout_path
	end
	it "displays the link to the profile page" do
		#session[:user_id] = user.id
		log_in_as(user)
    	#@user = user
    	#@current_user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", user_path(user)
	end
	it "does not display the link to the login page" do
		log_in_as(user)
		#session[:user_id] = user.id
    	#@user = user
    	#@current_user = user
		render template: "users/show.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", login_path, count: 0
	end
end