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

      User.online.find_each do |user|
        rendered_html = ApplicationController.render(
          partial: 'home/player_crypto_assets_list',
          locals: {
            crypto_assets: user.crypto_assets.includes(crypto_currency: :crypto_price),
            common_balance: user.common_balance
          }
        )

        Turbo::StreamsChannel.broadcast_update_to(
          "user_#{user.id}_crypto_assets",
          target: 'player-crypto-assets',
          html: rendered_html
        )
      end
    end
  end
end
