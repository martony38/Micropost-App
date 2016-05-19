FactoryGirl.define do

	factory :mickey, class: User do
		name "Mickey Mouse"
		email "mickey.mouse@gmail.com"
		email_confirmation "mickey.mouse@gmail.com"
		password "squick"
		password_confirmation "squick"
		admin true
	end

	factory :donald, class: User do
		name "Donald Duck"
		email "donald.duck@gmail.com"
		email_confirmation "donald.duck@gmail.com"
		password "coincoin"
		password_confirmation "coincoin"
		admin true
	end

	factory :random_user, class: User do
		sequence(:name) { |n| "Random User#{n}" }
		sequence(:email) { |n| "random.user#{n}@example.com" }
		email_confirmation { "#{email}" }
		sequence(:password) { |n| "password#{n}" }
		password_confirmation { "#{password}" }
	end

end