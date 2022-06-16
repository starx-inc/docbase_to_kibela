module Kibela::Client
  extend ActiveSupport::Concern
  require "graphql/client"
  require "graphql/client/http"

  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new(ENV.fetch('KIBELA_ENDPOINT')) do
    def headers(context)
      # Optionally set any HTTP headers
      { "Authorization": "Bearer #{ENV.fetch('KIBELA_TOKEN')}" }
    end
  end  
  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)

  # However, it's smart to dump this to a JSON file and load from disk
  #
  # Run it from a script or rake task
  #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
  #
  # Schema = GraphQL::Client.load_schema("path/to/schema.json")

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end