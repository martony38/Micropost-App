require 'rails_helper'

RSpec.describe "New", type: :request do

	describe "GET /new" do

		it "works! (now write some real specs)" do
      		get new_password_reset_path
      		expect(response).to have_http_status(200)
    	end

    	it "displays the login page" do
		  	get new_password_reset_path
		  	expect(response).to render_template('password_resets/new')
	  	end

	end

	describe "POST /new" do

		context "with invalid info" do

			it "does not send password reset email" do
				expect { post password_resets_path, password_reset: { email: "invalid@email.com" } }.to_not change{ActionMailer::Base.deliveries.size}
			end

			it "flashes error" do
				post password_resets_path, password_reset: { email: "invalid@email.com" }
				assert flash[:danger]
			end

			it "renders password_resets/new" do
				post password_resets_path, password_reset: { email: "invalid@email.com" }
				expect(response).to render_template('password_resets/new')
			end

		end

		context "with valid info" do

			let(:user) { user = create(:random_user) }

			it "changes the reset_digest attribute" do
				#expect{ post password_resets_path, password_reset: { email: user.email } }.to change{user.reset_digest}
				post password_resets_path, password_reset: { email: user.email }
				expect(user.reset_digest).to_not eq(user.reload.reset_digest)
			end

			it "sends one password reset email" do
				expect { post password_resets_path, password_reset: { email: user.email } }.to change{ActionMailer::Base.deliveries.size}.by(1)
			end

			it "flashes info" do
				post password_resets_path, password_reset: { email: user.email }
				assert flash[:info]
			end

			it "redirects to root" do
				post password_resets_path, password_reset: { email: user.email }
				expect(response).to redirect_to(root_path)
			end

		end

	end

end

RSpec.describe "Edit", type: :request do

	describe "GET /edit" do

		context "when user has not been activated yet" do

			it "redirects to root" do
				user = create(:unactivated_user)
				post password_resets_path, password_reset: { email: user.email }
				user = assigns(:user)
				get edit_password_reset_path(user.reset_token, email: user.email)
				expect(response).to redirect_to(root_path)
			end

		end

		context "when user has been activated" do

			let(:user) { create :random_user }

			context "with wrong email" do

				it "redirects to root" do
					#user = create(:random_user)
					post password_resets_path, password_reset: { email: user.email }
					user = assigns(:user)
					get edit_password_reset_path(user.reset_token, email: "wrong@email.	com")
					expect(response).to redirect_to(root_path)
				end

			end

			context "with wrong token" do

				it "redirects to root" do
					#user = create(:random_user)
					post password_resets_path, password_reset: { email: user.email }
					user = assigns(:user)
					get edit_password_reset_path("wrong_token", email: user.email)
					expect(response).to redirect_to(root_path)
				end

			end

			context "with valid info" do

				it "render password_resets/edit" do
					#user = create(:random_user)
					post password_resets_path, password_reset: { email: user.email }
					user = assigns(:user)
					get edit_password_reset_path(user.reset_token, email: user.email)
					expect(response).to render_template('password_resets/edit')
					assert_select "input[name=email][type=hidden][value=?]", user.email
				end

			end

		end

	end

	describe "PATCH /edit" do

		let(:user) { create :random_user }

		context "with valid info" do

			it "logs in user" do
				user.create_reset_digest
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "newpassword", password_confirmation: "newpassword" }
				expect(is_logged_in?).to eq(true)
			end

			it "flashes success" do
				user.create_reset_digest
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "newpassword", password_confirmation: "newpassword" }
				assert flash[:success]
			end

			it "redirects to user page" do
				user.create_reset_digest
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "newpassword", password_confirmation: "newpassword" }
				expect(response).to redirect_to(user)
			end

		end

		context "with invalid info" do

			it "does not log in user" do
				user.create_reset_digest
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "password", password_confirmation: "wrong_password" }
				expect(is_logged_in?).to eq(false)
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "", password_confirmation: "" }
				expect(is_logged_in?).to eq(false)
			end

			it "shows errors" do
				user.create_reset_digest
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "password", password_confirmation: "wrong_password" }
				assert_select 'div#error_explanation'
				patch password_reset_path(user.reset_token), email: user.email, user: { password: "", password_confirmation: "" }
				assert_select 'div#error_explanation'
			end

		end

	end

end