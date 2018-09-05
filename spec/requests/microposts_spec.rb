require 'rails_helper'

RSpec.describe "Index", type: :request do

	describe "POST /microposts" do

		context "when user logged in" do

			before do
				log_in_as(user = create(:user_with_microposts))
			end

			context "with invalid content" do

				it "does not create micropost" do
					expect{post microposts_path, micropost: { content: "" }}.to_not 	change{Micropost.count}
				end

				it "displays errors" do
					post microposts_path, micropost: { content: "" }
					assert_select "div#error_explanation"
				end

			end

			context "with valid content" do

				it "creates micropost" do
					picture = fixture_file_upload("rails.png", "image/png")
					expect{post microposts_path, micropost: { content: "valid content", picture: picture }}	.to change{Micropost.count}.by(1)
				end

				it "redirects to root" do
					content = "valid content"
					post microposts_path, micropost: { content: content }
					expect(response).to redirect_to(root_path)
					follow_redirect!
					expect(response.body).to match(content)
				end

			end

		end

	end

	describe "DELETE /micropost" do

		context "when user logged in" do

			let(:user) {create(:user_with_microposts)}
			before do
				log_in_as(user)
			end

			it "deletes the micropost post" do
				first_micropost = user.microposts.paginate(page: 1).first
				expect{ delete micropost_path(first_micropost) }.to change{Micropost.count}.by(-1)
			end

		end

	end

end
