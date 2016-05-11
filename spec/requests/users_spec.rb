require 'rails_helper'

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

    it "should no create a new user with invalid signup info" do
      expect{ post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }.to_not change{User.count}
    end

    it "should redirect to /users/new if failed to create new user" do
      post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
      expect(response).to render_template('users/new')
    end

    it "should report error messages about invalid signup info" do
      post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
      expect(response.body).to include("Name can&#39;t be blank" && "Email is invalid" && "Password confirmation doesn&#39;t match Password" && "Password is too short (minimum is 6 characters)")
    end
=begin
      assigns(:user).errors.full_messages.each do |msg|
        expect(response.body).to include(msg)
      end
=end

    it "should create a new user with valid signup info" do
      expect{ post users_path, user: { name: "Mickey Mouse", email: "mickey.mouse@gmail.com", password: "squick", password_confirmation: "squick" } }.to change{User.count}.by(1)
    end

    it "should redirect to newly created user show page if successful" do
      post users_path, user: { name: "Donald Duck", email: "donald.duck@gmail.com", password: "coincoin", password_confirmation: "coincoin" }
      expect(response).to redirect_to(assigns(:user))
    end

    it "should display /users/show if successfully created new user" do
      post users_path, user: { name: "Donald Duck", email: "donald.duck@gmail.com", password: "coincoin", password_confirmation: "coincoin" }
      follow_redirect!
      expect(response).to render_template(:show)
    end

    it "should flash success if successfully created new user" do
      post users_path, user: { name: "Donald Duck", email: "donald.duck@gmail.com", password: "coincoin", password_confirmation: "coincoin" }
      follow_redirect!
      expect(response.body).to include(flash[:success])
    end

  end

end