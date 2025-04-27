class CryptoAsset < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :user
  belongs_to :crypto_currency

  before_create :set_initial_price

  delegate :current_price, to: :crypto_currency

  private

  def set_initial_price
    self.initial_price = crypto_currency.current_price
  end
end
