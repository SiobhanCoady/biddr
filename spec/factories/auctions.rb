FactoryGirl.define do
  factory :auction do
    association :user, factory: :user

    sequence(:title)  { |n| "#{Faker::Commerce.product_name} #{n}" }
    details           { Faker::Hipster.paragraph}
    ends_on           { 60.days.from_now }
    reserve_price     { 20 }
    current_price     { 1 }
    aasm_state        { 'published' }
  end
end
