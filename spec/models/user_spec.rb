require 'rails_helper'


RSpec.describe User, type: :model do

	let (:user) {User.new(name: "Example User", email: "user@example.com", email_confirmation: "user@example.com", password: "foobar", password_confirmation: "foobar")}

	it "should be valid" do
		assert user.valid?
	end

	it "name should be present" do
		user.name = "      "
		expect(user.valid?).to eq(false)
	end

	it "email should be present" do
		user.email = user.email_confirmation = "      "
		expect(user.valid?).to eq(false)
	end

	it "name should not be too long" do
		user.name = "a" * 51
		expect(user.valid?).to eq(false)
	end

	it "email should not be too long" do
		user.email = user.email_confirmation = "a" * 244 + "@example.com"
		expect(user.valid?).to eq(false)
	end

	it "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			user.email = user.email_confirmation = valid_address
			expect(user.valid?).to eq(true), '#{valid_address.inspect} should be valid'
		end
	end

	it "email validation should reject invalid addresses" do
		invalid_addresses  = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			user.email = user.email_confirmation = invalid_address
			expect(user.valid?).to eq(false), '#{invalid_address.inspect} should be invalid'
		end
	end

	it "email addresses should be unique" do
		duplicate_user = user.dup
		duplicate_user.email = duplicate_user.email_confirmation = user.email.upcase
		user.save
		expect(duplicate_user.valid?).to eq(false)
	end

	it "email addresses should be saved as lower-case" do
		mixed_case_email = "Foo@ExaMple.CoM"
		user.email = user.email_confirmation = mixed_case_email
		user.save
		expect(user.email).to eq(mixed_case_email.downcase)
	end

  	it "email and email_confirmation should match" do
    	user.email_confirmation = "a" + user.email
    	expect(user.valid?).to eq(false)
  	end

	it "password should be present (nonblank)" do
		user.password = user.password_confirmation = " " * 6
		expect(user.valid?).to eq(false)
	end

	it "password should have a minimum length" do
		user.password = user.password_confirmation = "a" * 5
		expect(user.valid?).to eq(false)
	end

  	it "authenticated? should return false for a user with nil digest" do
    	expect(user.authenticated?(:remember, '')).to eq(false)
  	end

  	context "when user destroyed" do

  		it "destroys associated microposts" do
  			user.save
  			user.microposts.create!(content: "Lorem ipsum")
  			expect { user.destroy }.to change{Micropost.count}.by(-1)
  		end

  	end

end
