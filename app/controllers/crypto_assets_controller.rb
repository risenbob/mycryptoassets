class CryptoAssetsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @crypto_asset = CryptoAsset.new(crypto_asset_params.merge(user_id: current_user.id))

    if @crypto_asset.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @crypto_asset = CryptoAsset.find(params[:id])
  end

  def update
    @crypto_asset = CryptoAsset.find(params[:id])

    if @crypto_asset.update(crypto_asset_params)
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @crypto_asset = CryptoAsset.find(params[:id])

    if @crypto_asset.destroy
      redirect_to root_path
    end
  end

  private

  def crypto_asset_params
    params.require(:crypto_asset).permit(:crypto_currency_id, :quantity)
  end
end
