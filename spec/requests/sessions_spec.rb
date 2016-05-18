require 'rails_helper'

RSpec.describe "New", type: :request do

  let(:user) { create :donald }
  let(:invalid_login) { { email: "", password: "" } }
  let(:valid_login) { { email: user.email, password: user.password } }

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

    it "display login page if entered invalid login info" do
      post login_path, session: invalid_login
      expect(response).to render_template('sessions/new')
    end

    it "flashes danger if entered invalid login info" do
      post login_path, session: invalid_login
      assert flash[:danger]
    end

    it "should not flashes danger anymore when visiting another page after entered invalid login info" do
      post login_path, session: invalid_login
      get root_path
      assert_nil flash[:danger]
    end

    it "redirect to personal page after login with valid info" do
      post login_path, session: valid_login
      expect(response).to redirect_to(user)
    end

    it "actually login with valid info" do
      post login_path, session: valid_login
      assert is_logged_in?
    end

    it "displays users page if entered valid login info" do
      post login_path, session: valid_login
      follow_redirect!
      expect(response).to render_template('users/show')
    end

    it "login with remembering" do
      log_in_as(user, remember_me: "1")
      #expect(cookies["remember_token"]).to_not eq(nil)
      expect(cookies["remember_token"]).to eq(assigns(:user).remember_token)
    end

    it "login without remembering" do
      log_in_as(user, remember_me: "0")
      expect(cookies["remember_token"]).to eq(nil)
    end

  end

  describe "DELETE /logout" do

    it "user should not be logged in after logging out" do
      post login_path, session: valid_login
      delete logout_path, session: { user_id: user.id }
      expect(is_logged_in?).to eq(false)
    end

    it "should redirect to root after logging out" do
      post login_path, session: valid_login
      delete logout_path, session: { user_id: user.id }
      expect(response).to redirect_to(root_path)
    end

    it "should not raise an error if trying to logout a not logged in user" do
      delete logout_path, session: { user_id: user.id }
      expect(response).to have_http_status(302)
    end

  end

end