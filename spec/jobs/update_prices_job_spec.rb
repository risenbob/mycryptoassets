require 'rails_helper'

RSpec.describe UpdatePricesJob, type: :job do
  subject(:invoke_job) { described_class.perform_now }

  let(:crypto_currency) { create(:crypto_currency, name: 'Bitcoin') }
  let(:client) { instance_double('Coingecko::Client') }
  let(:new_prices) do
    {
      'bitcoin' => { 'usd' => 40000 },
      'ethereum' => { 'usd' => 3000 }
    }
  end

  before do
    allow(Coingecko::Client).to receive(:new).and_return(client)
    allow(client).to receive(:fetch_prices).and_return(new_prices)
  end

  describe '#perform' do
    context 'when prices are returned successfully' do
      let!(:crypto_currency) { create(:crypto_currency, name: 'Bitcoin') }

      it 'updates prices for the corresponding cryptocurrencies' do
        invoke_job

        crypto_price = crypto_currency.reload.crypto_price
        expect(crypto_price).to be_present
        expect(crypto_price.price).to eq(40000)
        expect(crypto_currency.crypto_price).to eq(crypto_price)
      end

      it 'skips cryptocurrencies that don’t exist in the database' do
        expect {
          invoke_job
        }.to change(CryptoPrice, :count).by(1) # Only 1 price update should be created (Bitcoin)
      end

      it 'creates a transaction when updating the cryptocurrency prices' do
        expect {
          invoke_job
        }.to change { CryptoPrice.count }.by(1)

        # After running the job, check that there is no failed state
        expect(CryptoCurrency.find_by(name: 'Bitcoin').crypto_price).to be_present
      end

      it 'does not create a price if the price is nil or missing' do
        allow(client).to receive(:fetch_prices).and_return(nil)

        expect {
          invoke_job
        }.not_to change(CryptoPrice, :count)
      end
    end

    context 'when no prices are returned from the API' do
      it 'does nothing and does not update any prices' do
        # Mock the API to return an empty response
        allow(client).to receive(:fetch_prices).and_return({})

        expect {
          invoke_job
        }.not_to change(CryptoPrice, :count)
      end
    end
  end
end
