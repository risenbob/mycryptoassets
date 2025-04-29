class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :crypto_assets

  scope :online, -> { all }

  def common_balance
    crypto_assets.includes(crypto_currency: :crypto_price).map { |a| a.quantity * a.current_price.to_d }.sum
  end
end
