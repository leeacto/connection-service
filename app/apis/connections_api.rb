class ConnectionsApi < Grape::API
  desc 'Get a list of connections'
  params do
    optional :ids, type: Array, desc: 'Array of connection ids'
  end
  get do
    connections = params[:ids] ? Connection.where(id: params[:ids]) : Connection.all
    represent connections, with: ConnectionRepresenter
  end

  desc 'Create a connection'
  params do
    requires :merchant_id, type: Integer, desc: "Hashed Screen Name of Merchant"
    requires :user_id, type: Integer, desc: "Hashed Screen Name of User"
  end

  post do
    connection = Connection.create(permitted_params)
    represent connection, with: ConnectionRepresenter
  end

  params do
    requires :id, desc: 'ID of the connection'
  end
  route_param :id do
    desc 'Get a connection'
    get do
      connection = Connection.find(params[:id])
      represent connection, with: ConnectionRepresenter
    end
  end
end
