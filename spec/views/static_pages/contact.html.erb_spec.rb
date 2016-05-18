require 'rails_helper'

RSpec.describe "static_pages/contact.html.erb", type: :view do
    it "displays the correct page title" do
    	render template: "static_pages/contact.html.erb", layout: "layouts/application.html.erb"
      	assert_select "title", "Contact | Lolo Cool Website"
    end
end