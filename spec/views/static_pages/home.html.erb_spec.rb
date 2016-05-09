require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
    it "displays the correct page title" do
    	render template: "static_pages/home.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "Ruby on Rails Tutorial Sample App"
    end
end
