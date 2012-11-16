FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "username#{n}@example.com" }
    password "secret"
    password_confirmation "secret"
  end   
  
  factory :category do
    sequence(:name) { |n| "category name #{n}"}
  end 
  
  factory :product do
    sequence(:name) { |n| "category name #{n}"}
    category = create(:category)
    price = 1 + rand(9)  
    released_at = Time.now - rand(20).days
  end
end