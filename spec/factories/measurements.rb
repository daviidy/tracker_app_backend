FactoryBot.define do
  factory :measurement do
    value { Faker::Number.decimal }
    date { Date.today }
  end
end
