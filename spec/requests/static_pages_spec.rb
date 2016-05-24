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

    context "when logged in" do

      it "displays the user's feed with the delete links" do
        log_in_as(user = create(:user_with_microposts))
        get root_path
        assert_select "div.pagination"
        assert_select "a", text: "delete"
      end

      it "displays the correct total number of microposts from user" do
        log_in_as(user = create(:user_with_microposts))
        get root_path
        expect(response.body).to match("#{user.microposts.count} microposts")
        log_in_as(user = create(:user_with_microposts, microposts_count: 1))
        get root_path
        expect(response.body).to match("1 micropost")
        log_in_as(user = create(:random_user))
        get root_path
        expect(response.body).to match("0 microposts")
      end

    end

  end

end