class ConnectionsApi < Grape::API
  desc 'Get a list of connections'
  params do
    optional :ids, type: Array, desc: 'Array of connection ids'
  end
  get do
    connections = params[:ids] ? Connection.where(id: params[:ids]) : Connection.all
    represent connections, with: ConnectionRepresenter
  end

  desc 'Create an connection'
  params do
  end

  post do
    connection = Connection.create!(permitted_params)
    represent connection, with: ConnectionRepresenter
  end

  params do
    requires :id, desc: 'ID of the connection'
  end
  route_param :id do
    desc 'Get an connection'
    get do
      connection = Connection.find(params[:id])
      represent connection, with: ConnectionRepresenter
    end

    desc 'Update an connection'
    params do
    end
    put do
      # fetch connection record and update attributes.  exceptions caught in app.rb
      connection = Connection.find(params[:id])
      connection.update_attributes!(permitted_params)
      represent connection, with: ConnectionRepresenter
    end
  end
end
