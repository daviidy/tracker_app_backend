FactoryBot.define do
  factory :measurement do
    value { Faker::Number.decimal }
    date { Date.today - Faker::Number.number(3).to_i.days }
  end
end