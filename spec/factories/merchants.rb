FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name }
    id { Faker::Number.number(digits: 3) }
  end
end
