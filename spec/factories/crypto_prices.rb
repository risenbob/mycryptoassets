FactoryBot.define do
  factory :crypto_price do
    price { 40_000.0 }
    crypto_currency
  end
end
