require 'rails_helper'

RSpec.describe "static_pages/help.html.erb", type: :view do
    it "displays the correct page title" do
    	render template: "static_pages/help.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "Help | Micropost App"
    end
end
