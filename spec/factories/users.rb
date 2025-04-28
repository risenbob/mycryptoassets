FactoryBot.define do
  factory :user do
    email { "n#{rand(100)}H@example.com" }
    password { "password" }
  end
end
