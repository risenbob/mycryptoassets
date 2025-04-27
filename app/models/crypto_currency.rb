class CryptoCurrency < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  belongs_to :crypto_price, optional: true

  def current_price
    crypto_price&.price
  end
end
