class ConnectionRepresenter < Napa::Representer
  property :id, type: String
  property :user_id
  property :merchant_id
  property :first_visit

end
