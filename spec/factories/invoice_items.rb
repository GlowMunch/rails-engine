FactoryBot.define do
  factory :invoice_item do
    invoice_id { nil }
    item_id { nil }
    quantity { Faker::Number.number(digits: 3) }
    unit_price { Faker::Number.number(digits:2) }
  end
end
