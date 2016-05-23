FactoryGirl.define do

	factory :unactivated_user, class: User do
		sequence(:name) { |n| "Random User#{n}" }
		sequence(:email) { |n| "random.user#{n}@example.com" }
		email_confirmation { "#{email}" }
		sequence(:password) { |n| "password#{n}" }
		password_confirmation { "#{password}" }

		factory :random_user do
			activated true
			activated_at Time.zone.now

			factory :admin_user do
				admin true

				factory :mickey do
					name "Mickey Mouse"
					email "mickey.mouse@gmail.com"
					email_confirmation "mickey.mouse@gmail.com"
					password "squick"
					password_confirmation "squick"
				end

				factory :donald do
					name "Donald Duck"
					email "donald.duck@gmail.com"
					email_confirmation "donald.duck@gmail.com"
					password "coincoin"
					password_confirmation "coincoin"
				end

			end

			factory :user_with_microposts do
				transient do
					microposts_count 40
				end
				after(:create) do |user, evaluator|
        			create_list(:micropost, evaluator.microposts_count, user: user)
      			end
			end

		end

	end

end