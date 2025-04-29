class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @crypto_assets = current_user.crypto_assets.includes(crypto_currency: :crypto_price)
    @common_balance = current_user.common_balance
  end
end
