require 'rails_helper'

RSpec.describe "Index", type: :request do

	before do
		@user = create(:random_user)
		@other_user = create(:random_user)
		log_in_as(@user)
	end

	describe "POST /relationships" do

		it "follows a user the standard way (html)" do
			expect{ post relationships_path, followed_id: @other_user.id }.to change{@user.following.count}.by(1)
		end

		it "follows a user with Ajax" do
			expect{ xhr :post, relationships_path, followed_id: @other_user.id }.to change{@user.following.count}.by(1)
		end

	end

	describe "DELETE /relationship" do

		before do
			@user.follow(@other_user)
			@relationship =@user.active_relationships.find_by(followed_id: @other_user.id)
		end

		it "unfollows a user the standard way (html)" do
			expect{ delete relationship_path(@relationship) }.to change{@user.following.count}.by(-1)
		end

		it "unfollows a user with Ajax" do
			expect{ xhr :delete, relationship_path(@relationship) }.to change{@user.following.count}.by(-1)
		end

	end

end