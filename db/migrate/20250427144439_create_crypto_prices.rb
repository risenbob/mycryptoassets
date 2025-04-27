class CreateCryptoPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :crypto_prices do |t|
      t.references :crypto_currency, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
