module Services

  class Merchants
  include HTTParty

    base_uri 'localhost:9394'

    def self.find(merchant_id)
      self.get("/merchants/#{merchant_id}")
    end
  end
end
