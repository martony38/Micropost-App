require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do

	describe "POST #create" do

		it "requires logged in user" do
			expect{ post :create }.to_not change{Relationship.count}
			expect(response).to redirect_to(login_path)
		end

	end

	describe "POST #destroy" do

		it "requires logged in user" do
			relationship = create(:relationship)
			expect{ delete :destroy, id: relationship }.to_not change{Relationship.count}
			expect(response).to redirect_to(login_path)
		end

	end

end
