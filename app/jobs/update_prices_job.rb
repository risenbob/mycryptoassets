class UpdatePricesJob < ApplicationJob
  queue_as :default

  def perform
    new_prices = Coingecko::Client.new.fetch_prices(CryptoCurrency.pluck(:name).map(&:downcase))

    if new_prices.present?
      new_prices.each do |coin, price|
        price = price['usd']

        currency = CryptoCurrency.find_by(name: coin.capitalize)

        next unless currency

        ApplicationRecord.transaction do
          crypto_price = CryptoPrice.create!(price: price, crypto_currency: currency)
          currency.update!(crypto_price: crypto_price)
        end
      end

      # broadcast changes for online users via action cable
    end
  end
end
