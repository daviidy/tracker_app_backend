FactoryBot.define do
  factory :habit do
    name { Faker::Name.name }
  end
end
