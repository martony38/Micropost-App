FactoryGirl.define do
  factory :relationship do
    sequence(:follower_id) { |n| n }
    followed_id { follower_id + 1 }
  end
end
