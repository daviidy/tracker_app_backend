FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email(Faker::Name.name) }
    password { Faker::Internet.password }
  end
end
