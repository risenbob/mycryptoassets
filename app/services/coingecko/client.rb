class Coingecko::Client
  include HTTParty
  base_uri 'https://api.coingecko.com/api/v3'

  def initialize
    @options = { query: { localization: false } }
  end

  def fetch_prices(currencies)
    response = self.class.get("/simple/price", { query: { ids: currencies, vs_currencies: 'usd' } })

    if response.success?
      response.parsed_response
    else
      response
    end
  end
end
