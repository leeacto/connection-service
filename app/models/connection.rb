class Connection < ActiveRecord::Base
  require './lib/services/users_service.rb'
  require './lib/services/merchants_service.rb'

  attr_accessor :first_visit
  
  validate      :fresh_connection, message: "Last User Check-In was too recent"

  def self.last_connection(user_id, merchant_id)
    Connection.where(user_id: user_id, merchant_id: merchant_id).order('created_at desc').first
  end

  def fresh_connection
    merchant = Services::Merchants.find(merchant_id)
    user = Services::Users.find(user_id)

    return errors.add(:merchant_id, "does not exist") if merchant[:error]
    return errors.add(:user_id, "does not exist") if user[:error]

    last_connection = self.class.last_connection(user_id, merchant_id)
    unless last_connection.nil? || merchant[:data][:ttl] == 0 || last_connection.created_at + (3600 * merchant[:data]['ttl']) < Time.now
      return errors.add(:created_at, "connection created too recently")
    end

    self.first_visit = true if last_connection.nil?
  end
end
