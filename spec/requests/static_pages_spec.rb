require 'rails_helper'

RSpec.describe "Home", type: :request do

  describe "GET /" do

    it "works! (now write some real specs)" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "displays the home page" do
		  get root_path
		  #assert_template 'static_pages/home'
		  expect(response).to render_template('static_pages/home')
	  end

  end

end