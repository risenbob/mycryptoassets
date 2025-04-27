class CryptoCurrency < ApplicationRecord
  validates :name, :code, presence: true

  belongs_to :crypto_price, optional: true

  def current_price
    crypto_price&.price
  end
end
