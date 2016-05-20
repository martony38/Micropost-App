require 'rails_helper'

RSpec.describe "Edit", type: :request do

	describe "GET /Edit" do

		let(:user) { create :unactivated_user }

		context "with invalid activation token" do

			it "does not activate user" do
				get edit_account_activation_path("invalid token", email: user.email)
				expect(user.reload.activated?).to eq(false)
			end

		end

		context "with wrong email" do

			it "does not activate user" do
				get edit_account_activation_path(user.activation_token, email: "wrong@email.com")
				expect(user.reload.activated?).to eq(false)
			end

		end

		context "with valid activation info" do

			it "activates user" do
				get edit_account_activation_path(user.activation_token, email: user.email)
				expect(user.reload.activated?).to eq(true)
			end

			it "redirects to newly created user show page" do
		        get edit_account_activation_path(user.activation_token, email: user.email)
		        expect(response).to redirect_to(user_path(user))
		    end

		    it "displays /users/show" do
		        get edit_account_activation_path(user.activation_token, email: user.email)
		        follow_redirect!
		        expect(response).to render_template('users/show')
		    end

		    it "flashes success" do
		        get edit_account_activation_path(user.activation_token, email: user.email)
		        follow_redirect!
		        assert flash[:success]
		    end

		    it "logs in newly created user" do
		        get edit_account_activation_path(user.activation_token, email: user.email)
		        assert is_logged_in?
		    end

		end

	end

end