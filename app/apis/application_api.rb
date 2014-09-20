class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount ConnectionsApi => '/connections'

  add_swagger_documentation
end

