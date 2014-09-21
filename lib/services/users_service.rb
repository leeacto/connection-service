module Services

  class Users
    include HTTParty
    base_uri 'localhost:9393'

    def self.find(user_id)
      self.get("/users/#{user_id}")
    end
  end
end
