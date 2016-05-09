require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
    it "displays the correct page title" do
    	render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "Ruby on Rails Tutorial Sample App"
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
end
