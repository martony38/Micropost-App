require 'rails_helper'

=begin
def is_logged_in?
  !session[:user_id].nil?
end
=end

RSpec.describe "New", type: :request do

  describe "GET /signup" do

    it "works!" do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it "displays the signup page" do
      get signup_path
      expect(response).to render_template('users/new')
    end

  end

  describe "POST /users" do

    let(:valid_attributes) { attributes_for :donald }
    let(:invalid_attributes) { { name: "", email: "user@invalid", email_confirmation: "user@veryinvalid", password: "foo", password_confirmation: "bar" } }

    it "should no create a new user with invalid signup info" do
      expect{ post users_path, user: invalid_attributes }.to_not change{User.count}
    end

    it "should redirect to /users/new if failed to create new user" do
      post users_path, user: invalid_attributes
      expect(response).to render_template('users/new')
    end

    it "should report error messages about invalid signup info" do
      post users_path, user: invalid_attributes
      expect(response.body).to include("Name can&#39;t be blank" && "Email is invalid" && "Email confirmation doesn&#39;t match Email" && "Password confirmation doesn&#39;t match Password" && "Password is too short (minimum is 6 characters)")
=begin
      assigns(:user).errors.full_messages.each do |msg|
        expect(response.body).to include(msg)
      end
=end
    end

    it "should create a new user with valid signup info" do
      expect{ post users_path, user: valid_attributes }.to change{User.count}.by(1)
    end

    it "should redirect to newly created user show page if successful" do
      post users_path, user: valid_attributes
      expect(response).to redirect_to(assigns(:user))
    end

    it "should display /users/show if successfully created new user" do
      post users_path, user: valid_attributes
      follow_redirect!
      expect(response).to render_template(:show)
    end

    it "should flash success if successfully created new user" do
      post users_path, user: valid_attributes
      follow_redirect!
      #expect(response.body).to include(flash[:success])
      assert flash[:success]
    end

    it "should login newly created user" do
      post users_path, user: valid_attributes
      assert is_logged_in?
    end

  end

end