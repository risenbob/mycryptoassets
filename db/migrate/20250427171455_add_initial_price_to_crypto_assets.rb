class AddInitialPriceToCryptoAssets < ActiveRecord::Migration[8.0]
  def change
    add_column :crypto_assets, :initial_price, :decimal
  end
end
