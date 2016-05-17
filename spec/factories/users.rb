FactoryGirl.define do
	factory :mickey, class: User do
		name "Mickey Mouse"
		email "mickey.mouse@gmail.com"
		password "squick"
		password_confirmation "squick"
		#password_digest User.digest("squick")
	end
	factory :donald, class: User do
		name "Donald Duck"
		email "donald.duck@gmail.com"
		password "coincoin"
		password_confirmation "coincoin"
		#password_digest User.digest("coincoin")
	end
end