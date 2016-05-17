require 'rails_helper'

RSpec.describe "New", type: :request do

  describe "GET /login" do

    it "works! (now write some real specs)" do
      get login_path
      expect(response).to have_http_status(200)
    end

    it "displays the login page" do
		  get login_path
		  expect(response).to render_template('sessions/new')
	  end

  end

  describe "POST /login" do

    let(:user) { create :donald }

    it "display login page if entered invalid login info" do
      post login_path, session: { email: "", password: "" }
      expect(response).to render_template('sessions/new')
    end

    it "flashes danger if entered invalid login info" do
      post login_path, session: { email: "", password: "" }
      assert flash[:danger]
    end

    it "should not flashes danger anymore when visiting another page after entered invalid login info" do
      post login_path, session: { email: "", password: "" }
      get root_path
      assert_nil flash[:danger]
    end

    it "redirect to personal page after login with valid info" do
      post login_path, session: { email: user.email, password: user.password }
      expect(response).to redirect_to(user)
    end

    it "actually login with valid info" do
      post login_path, session: { email: user.email, password: user.password}
      assert is_logged_in?
    end

    it "displays users page if entered valid login info" do
      post login_path, session: { email: user.email, password: user.password }
      follow_redirect!
      expect(response).to render_template('users/show')
    end

    it "login with remembering" do
      log_in_as(user, remember_me: "1")
      expect(cookies["remember_token"]).to_not eq(nil)
    end

    it "login without remembering" do
      log_in_as(user, remember_me: "0")
      expect(cookies["remember_token"]).to eq(nil)
    end

  end

  describe "DELETE /logout" do

    let(:user) { create :donald }

    it "user should not be logged in after logging out" do
      post login_path, session: { email: user.email, password: user.password}
      delete logout_path, session: { user_id: user.id }
      expect(is_logged_in?).to eq(false)
    end

    it "should redirect to root after logging out" do
      post login_path, session: { email: user.email, password: user.password}
      delete logout_path, session: { user_id: user.id }
      expect(response).to redirect_to(root_path)
    end

    it "should not raise an error if trying to logout a not logged in user" do
      delete logout_path, session: { user_id: user.id }
      expect(response).to have_http_status(302)
    end

  end

end