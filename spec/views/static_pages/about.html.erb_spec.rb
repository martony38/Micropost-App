require 'rails_helper'

RSpec.describe "static_pages/about.html.erb", type: :view do
    it "displays the correct page title" do
    	render template: "static_pages/about.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "About | Ruby on Rails Tutorial Sample App"
    end
end
