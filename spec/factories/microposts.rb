FactoryGirl.define do
  factory :micropost do
    content "Lorem ipsum"
    association :user, factory: :random_user
  end
end
