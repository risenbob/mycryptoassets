class UpdatePricesJob < ApplicationJob
  queue_as :default

  def perform
    new_prices = Coingecko::Client.new.fetch_prices(CryptoCurrency.pluck(:name).map(&:downcase))

    if new_prices.present?
      new_prices.each do |coin, price|
        price = price['usd']
        currency = CryptoCurrency.find_by(name: coin)

        next unless currency

        ApplicationRecord.transaction do
          crypto_price = CryptoPrice.create!(price: price, crypto_currency: currency)
          currency.update!(crypto_price: crypto_price)
        end
      end
    end
  end
end
