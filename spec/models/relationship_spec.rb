require 'rails_helper'

RSpec.describe Relationship, type: :model do

	let(:relationship) { create :relationship }

	it "should be valid" do
		expect(relationship.valid?).to eq(true)
	end

	it "requires a follower_id" do
		relationship.follower_id = nil
		expect(relationship.valid?).to eq(false)
	end

	it "requires a followed_id" do
		relationship.followed_id = nil
		expect(relationship.valid?).to eq(false)
	end

end
