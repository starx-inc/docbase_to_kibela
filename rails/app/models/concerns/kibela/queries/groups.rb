module Kibela::Queries::Groups
  extend ActiveSupport::Concern
  
  Query = Kibela::Client::Client.parse <<-'GRAPHQL'
    query($per: Int, $cursor: String) {
      groups(first: $per, after: $cursor) {
        nodes {
          id
          name
          path
        },
        pageInfo {
          endCursor
          hasNextPage
          hasPreviousPage
          startCursor
        }
      }
      budget {
        cost
        consumed
        remaining
      }
    }
  GRAPHQL
  
  def get_groups(cursor=nil, per=100)
    query(
      Query,
      variables: { cursor: cursor, per: per }
    )
  end
end