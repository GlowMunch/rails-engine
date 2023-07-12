FactoryBot.define do
  factory :item do
    name { Faker::Device.model_name }
    description { Faker::Cannabis.buzzword }
    unit_price { Faker::Number.number(digits: 2) }
    merchant_id { nil }
  end
end
