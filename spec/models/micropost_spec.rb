require 'rails_helper'

RSpec.describe Micropost, type: :model do

	let(:micropost) { create(:micropost) }

	it "is valid" do
		assert micropost.valid?
	end

	it "must have user id" do
		micropost.user_id = nil
		expect(micropost.valid?).to eq(false)
	end

	it "must have content" do
		micropost.content = "    "
		expect(micropost.valid?).to eq(false)
	end

	it "content is at most 140 characters" do
		micropost.content = "a" * 141
		expect(micropost.valid?).to eq(false)
	end

	it "orders by most recent" do
		oldest_micropost = create(:micropost)
		old_micropost = create(:micropost)
		new_micropost = create(:micropost)
		newest_micropost = create(:micropost)
		expect(newest_micropost).to eq(Micropost.first)
	end

end
