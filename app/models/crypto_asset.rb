class CryptoAsset < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :user
end
