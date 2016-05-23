require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do

	let(:user) { create :donald }

    it "displays the correct page title" do
    	render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "Lolo Cool Website"
    end

    it "displays the links to the home page" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", root_path, count: 2
	end

    it "displays the link to the help page" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", help_path
	end

    it "displays the link to the about page" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", about_path
	end

    it "displays the link to the contact page" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", contact_path
	end

	it "displays the link to the login page if user not logged in" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", login_path
	end

	it "does not display the link to the login page if user logged in" do
		session[:user_id] = user.id
		@micropost = user.microposts.build(content: "Lorem ipsum")
		@feed_items = []
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", login_path, count: 0
	end

	it "does not display the link to the logout page if user not logged in" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", logout_path, count: 0
	end

	it "does not display the link to the user page if user not logged in" do
		render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
		assert_select "a[href=?]", user_path(user), count: 0
	end

end
