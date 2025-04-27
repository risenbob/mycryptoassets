class CreateCryptoAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :crypto_assets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :crypto_currency, null: false, foreign_key: true
      t.decimal :quantity

      t.timestamps
    end
  end
end
