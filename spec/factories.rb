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
    sequence(:name) { |n| "product name #{n}"}
    category
    price { 100 + rand(1000001) }  
    released_at { Time.now - rand(20).days }
  end   
  
  factory :search do
    user
  end  
end