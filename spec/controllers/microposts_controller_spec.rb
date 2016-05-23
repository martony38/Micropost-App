require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

	describe "POST #create" do

		context "when not logged in" do

			it "does not create micropost" do
				expect{ post :create, micropost: { content: "lorem ipsum" } }.to_not change{Micropost.count}
			end

			it "redirects to login" do
				post :create, micropost: { content: "lorem ipsum" }
				expect(response).to redirect_to(login_path)
			end

		end

	end

	describe "DELETE #destroy" do

		context "when not logged in" do

			it "does not delete micropost" do
				micropost = create(:micropost)
				expect{ delete :destroy, id: micropost }.to_not change{ Micropost.count }
			end

			it "redirects to login" do
				micropost = create(:micropost)
				delete :destroy, id: micropost
				expect(response).to redirect_to(login_path)
			end

		end

		context "when logged in" do

			it "does not delete another user's micropost and redirects to root" do
				micropost = create(:micropost)
				log_in_as(user = create(:donald))
				expect{ delete :destroy, id: micropost }.to_not change{ Micropost.count }
				expect(response).to redirect_to(root_path)
			end

		end

	end

end
