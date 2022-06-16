module Kibela::Queries::Users
  extend ActiveSupport::Concern
  
  Query = Kibela::Client::Client.parse <<-'GRAPHQL'
    query($per: Int, $cursor: String) {
      users(first: $per, after: $cursor) {
        nodes {
          id
          account
          email
        },
        pageInfo {
          endCursor
          hasNextPage
          hasPreviousPage
          startCursor
        }
      }
    }
  GRAPHQL
  
  def get_users(cursor=nil, per=100)
    query(
      Query,
      variables: { cursor: cursor, per: per }
    )
  end
end