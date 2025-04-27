class AddCryptPriceToCryptoCurrencies < ActiveRecord::Migration[8.0]
  def change
    add_column :crypto_currencies, :crypto_price_id, :integer
  end
end
