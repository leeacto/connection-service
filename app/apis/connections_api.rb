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
    Napa::Logger.logger.info "Creating Connection: #{permitted_params}"
    connection = Connection.create(permitted_params)
    if connection.errors.blank?
      Napa::Logger.logger.info "Connection (id: #{connection.id}) successfully created"
      represent connection, with: ConnectionRepresenter
    else
      Napa::Logger.logger.info "Connection not created - error: #{connection.errors.full_messages.to_sentence}"
      error! connection.errors.full_messages.to_sentence, 400
    end
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

  desc 'Delete a connection'
  params do
    requires :id, desc: 'ID of the connection'
    requires :merchant_id, desc: 'ID of the merchant'
  end
  delete ':id' do
    connection = Connection.where(id: params[:id], merchant_id: params[:merchant_id]).first
    if connection
      connection.destroy
    else
      error! "Connection Not Found", 404
    end
  end

end
